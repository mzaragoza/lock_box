namespace :run do
  namespace :ctf do

    desc "CTF Challenge 13, 14, 32 from ringzer0team.com"
    task :challenge, [:challenge, :useranme, :password] => [:environment] do |task, args|
      connect_ringzer0team('https://ringzer0team.com', args.challenge, args.useranme, args.password)
    end

  end
end

def connect_ringzer0team(url=nil, challenge=nil, username=nil, password=nil)
  # Create Agent for populate login form
  @agent = Mechanize.new
  @agent.user_agent_alias = 'Android'
  login_page = @agent.get("#{url}/login")
  login_form = @agent.page.form_with(method: 'POST')
  login_form.username = username
  login_form.password = password
  doc         = @agent.page.parser
  js_string   = doc.search('script')
  class_key   = doc.css("input[name=csrf]").attr('class').value()
  new_string  = js_string.to_s.split(class_key)
  login_form.csrf = new_string[0].split("'")[1]
  @agent.submit(login_form)

  # Go to challenge url
  @agent.get("#{url}/challenges/#{challenge}") do |page|

    # Parse page
    doc       = page.parser

    # Parse message to decode
    @message  = doc.css('.message').text.gsub("\r\n\t\t", "").gsub("----- BEGIN MESSAGE -----","").gsub("----- END MESSAGE -----","")

    @answer   = to_ascii(@message) unless challenge.include? "14"
    @answer   = Digest::SHA2.new(512).hexdigest @message unless challenge.include? ("13" || "14")

    if challenge.include? "32"
      variables = @message.split(" ")
      @answer = calc(variables[3], calc(variables[1], variables[0].to_i, variables[2].to_i(16)), variables[4].to_i(2))
    end

    @agent.get("#{url}/challenges/#{challenge}/#{@answer}") do |page|
      doc = page.parser
      puts ""
      puts "Challenge: #{challenge} on #{url}"
      puts doc.css('.alert-info').text
      puts ""
    end
  end
end

def to_ascii(binary_str)
  binary_str.gsub(/\s/,'').gsub(/([01]{8})/) { |b| b.to_i(2).chr }
end

def calc(op, num1, num2)
  a = num1
  b = num2
  a.send(op,b)
end
