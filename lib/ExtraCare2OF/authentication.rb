require 'mechanize'
require 'open-uri'

module ExtraCare2OF
  class Authentication

    def initialize(args)
      @username = args[:username]
      @password = args[:password]
      @agent = Mechanize.new
    end

    def login
      page = @agent.get("https://m.cvs.com/mt/www.cvs.com/account/login.jsp")
      form = page.forms.first
      form['/atg/userprofiling/ProfileFormHandler.value.login']    = @username
      form['/atg/userprofiling/ProfileFormHandler.value.password'] = @password
      page = form.submit
      @page = page
      sleep 3
      # puts page.parser.xpath("//body").to_html
    end

    def request(page)
      time_key = Time.now.to_i
      page = @agent.get(page)
      page.parser.xpath("//body").to_html
    end

    def logged_in?
      /Welcome/.match(@page.parser.xpath("//body").to_html) == true
    end

  end
end
