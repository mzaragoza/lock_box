namespace :run do
  namespace :ctf do

    desc "CTF Challenge 13, 14 from ringzer0team.com"
    task :challenge, [:challenge, :useranme, :password] => [:environment] do |task, args|
      connect_ringzer0team('https://ringzer0team.com', args.challenge, args.useranme, args.password)
    end

  end
end

def connect_ringzer0team(url=nil, challenge=nil, username=nil, password=nil)
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
  @agent.get("#{url}/challenges/#{challenge}") do |page|
    doc = page.parser
    doc.css('.message').each do |node|
      if node.content=~/\S/
        node.content = node.content.strip
      else
        node.remove
      end
      @sha = node.content.gsub("\r\n\t\t", "").gsub("----- BEGIN MESSAGE -----","").gsub("----- END MESSAGE -----","")
    end
    if challenge.include? "14"
      @sha  = to_ascii(@sha)
    end
    @hash = Digest::SHA2.new(512).hexdigest @sha
    @agent.get("#{url}/challenges/#{challenge}/#{@hash}") do |page|
      doc = page.parser
      puts ""
      puts "Challenge: #{challenge} on #{url}"
      puts doc.css('.alert-info').text
      puts ""
    end
  end
end

def get_results(url='')
end

def to_ascii(binary_str)
  binary_str.gsub(/\s/,'').gsub(/([01]{8})/) { |b| b.to_i(2).chr }
end
