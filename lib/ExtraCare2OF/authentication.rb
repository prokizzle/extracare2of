require 'highline/import'

module Extracare2of
  class Authentication
    attr_reader :hash

    def initialize(*)
      load_session if session_exists?
      authenticate unless session_exists?
      @hash = Hash.new
    end

    def session_exists?
      File.exist?("#{ENV['HOME']}/.extracare2of/session.yml")
    end

    def load_session
      session_file = open("#{ENV['HOME']}/.extracare2of/session.yml")
      @agent = Mechanize.new do |a|
        a.cookie_jar = YAML.load(session_file)
      end
    end

    def authenticate
      @agent = Mechanize.new
      login
      open("#{ENV['HOME']}/.extracare2of/session.yml", 'w') { |f|
        f.puts @agent.cookie_jar.to_yaml
      }
    end

    def login
      page = @agent.get("https://m.cvs.com/mt/www.cvs.com/account/login.jsp")
      form = page.forms.first
      form['/atg/userprofiling/ProfileFormHandler.value.login']    = ask("username: ")
      form['/atg/userprofiling/ProfileFormHandler.value.password'] = ask("password: ")
      page = form.submit
      @page = page
      sleep 3
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
