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

    def request(link, request_id)
      @hash[request_id] = {ready: false}
      url = URI.escape(link)
      @agent.read_timeout=30
      temp = @agent.get(url)
      # @log.debug "#{@url}"
      returned_body = temp.parser.xpath("//body").to_html.to_s
      @hash[request_id] = {url: url.to_s, body: returned_body, html: temp, ready: true}
      {url: url.to_s, body: returned_body, html: temp, hash: request_id.to_i}
    end

    def logged_in?
      /Welcome/.match(@page.parser.xpath("//body").to_html) == true
    end

  end
end
