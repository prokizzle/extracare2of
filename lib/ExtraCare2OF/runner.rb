require_relative 'authentication'
require_relative 'settings'
require 'highline/import'
require 'appscript';include Appscript
require 'amatch';include Amatch
require 'chronic'

module ExtraCare2OF
  class Runner

    def initialize(args)
      @username = args[:username]
      @password = args[:password]

      @browser = Authentication.new(username: @username, password: @password)
      @settings = Settings.new(username: @username)
      my_rewards_link = "https://www.cvs.com/extracare/landing.jsp?t=mySavingRewards"
      @browser.login
      @rewards_source = @browser.request("https://m.cvs.com/mt/www.cvs.com/extracare/landing.jsp")
      # p @rewards_source
      of = app("OmniFocus")
      @dd= of.default_document
    end

    def async_response(url)
      request_id = Time.now.to_i
      @browser.request(url, request_id)
      until @browser.hash[request_id][:ready]
        sleep 0.1
      end
      @browser.hash[request_id]
    end

    def get_coupons
      @deals_array = Array.new
      rewards = @rewards_source.scan(/<div class="un_exEntry">\n<div><div class="un_red un_small un_bold">(.+)<.div><.div>\n<div class="un_xxsmall">(\d{2}\/\d{2}\/\d{4})<.div>\n<div class="un_xxsmall">(.+)<.div>\n<div class="un_xxsmall">\n<span class="prnted">Printed on (\d{2}\/\d{2}\/\d{4})<.span> <.div>/)
      rewards.each do |deal|
        title = deal[0]
        expire = deal[1]
        details = deal[2]
        print_date = deal[3]
        @deals_array.push({:name => title,:due_date => parse_date(expire), :note => details, :start_date => parse_date(print_date)})
      end
      # p rewards
      @deals_array
    end

    def send_bucks_to_card
      bucks = @rewards_source.scan(regex)
      bucks.each do |buck|
        link = buck.match(url)
        link_page = @browser.request(link)
        confirmation = @browser.request(button)
        if confirmation == regex
          puts "Extra Bucks sent to card"
        else
          puts "Error: Unable to send to card"
        end
      end
    end

    #borrowed from ttscoff's otask
    def parse_date(datestring)
      days = 0
      if datestring =~ /^\+(\d+)$/
        days = (60 * 60 * 24 * $1.to_i)
        newdate = Time.now + days
      else
        newdate = Chronic.parse(datestring, {:context => :future, :ambiguous_time_range => 8})
      end
      # parsed = newdate.strftime('%D %l:%M%p').gsub(/\s+/,' ');
      # return parsed =~ /1969/ ? false : parsed
      return newdate
    end

    def send_to_of(coupon)
      puts "----"
      puts " Title: #{coupon[:name]}"
      puts " - Due Date: #{coupon[:due_date]}"
      puts " - Start Date: #{coupon[:start_date]}"
      puts " - Note: #{coupon[:note]}"
      @dd.make(:new => :inbox_task, :with_properties => coupon.to_hash)
    end


    def run
      puts "Looking for coupons..."
      puts " - Sending #{get_coupons.size} tasks to OF"
      get_coupons.each {|coupon| send_to_of(coupon)}
      # puts "Sending extra bucks to card"
      # send_bucks_to_card
      # puts "Done"
      # exit
    end

  end
end
