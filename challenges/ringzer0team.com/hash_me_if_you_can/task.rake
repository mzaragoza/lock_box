namespace :run do
  namespace :ctf do

    desc "Hash me please"
    task :hash do

      connect_ringzer0team([USERNAME], [PASSWORD])

    end
  end
end

def connect_ringzer0team(username=nil, password=nil)
  @agent = Mechanize.new
  @agent.user_agent_alias = 'Android'
  login_page = @agent.get('https://ringzer0team.com/login')
  login_form = @agent.page.form_with(method: 'POST')
  login_form.username = username
  login_form.password = password

  doc         = @agent.page.parser
  js_string   = doc.search('script')
  class_key   = doc.css("input[name=csrf]").attr('class').value()
  new_string  = js_string.to_s.split(class_key)

  login_form.csrf = new_string[0].split("'")[1]
  @agent.submit(login_form)
  @agent.get("https://ringzer0team.com/challenges/13") do |page|
    doc = page.parser
    doc.css('.message').each do |node|
      if node.content=~/\S/
        node.content = node.content.strip
      else
        node.remove
      end
      #@sha = node.content.gsub("\r\n\t\t", "")
      @sha = node.content.gsub("\r\n\t\t", "").gsub("----- BEGIN MESSAGE -----","").gsub("----- END MESSAGE -----","")
    end
    #@page = @agent.post('https://ringzer0team.com/tool', { "input" => @sha, "action" => "sha512" })
    #@page = @page.parser
    #@hash = @page.css(".panel-default").text
    @hash = Digest::SHA2.new(512).hexdigest @sha
    @agent.get("https://ringzer0team.com/challenges/13/#{@hash}") do |page|
      doc = page.parser
      debugger
    end
  end
end

def get_results(url='')
end

