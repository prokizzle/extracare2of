require_relative 'authentication'
require_relative 'settings'
require_relative 'database'
require 'highline/import'
require 'appscript';include Appscript
require 'amatch';include Amatch
require 'chronic'

module ExtraCare2OF
  class Runner

    def initialize(args)
      @username = args[:username]
      @password = args[:password]
      @db       = Database.new(username: @username)
      @browser  = Authentication.new(username: @username, password: @password)
      @settings = Settings.new(username: @username)
      @browser.login
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
      @rewards_source = async_response("https://m.cvs.com/mt/www.cvs.com/extracare/landing.jsp")[:body]
      @deals_array = Array.new
      rewards = @rewards_source.scan(/<div class="un_exEntry">\n<div><div class="un_red un_small un_bold">(.+)<.div><.div>\n<div class="un_xxsmall">(\d{2}\/\d{2}\/\d{4})<.div>\n<div class="un_xxsmall">(.+)<.div>\n<div class="un_xxsmall">\n<span class="prnted">Printed on (\d{2}\/\d{2}\/\d{4})<.span> <.div>/)
      rewards.each do |deal|
        name = deal[0]
        due_date = deal[1]
        note = deal[2]
        start_date = deal[3]
        @deals_array.push({:name => name,:due_date => parse_date(due_date), :note => note, :start_date => parse_date(start_date)})
      end
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
      @count = 0
      # puts " - Sending #{get_coupons.size} tasks to OF"
      unless @db.coupon_exists?(coupon[:name])
        @db.add_coupon(name: coupon[:name], due_date: coupon[:due_date], start_date: coupon[:start_date])
        puts "----"
        puts " Title: #{coupon[:name]}"
        puts " - Due Date: #{coupon[:due_date]}"
        puts " - Start Date: #{coupon[:start_date]}"
        puts " - Note: #{coupon[:note]}"
        @dd.make(:new => :inbox_task, :with_properties => coupon.to_hash)
        @count += 1
      end
    end


    def run
      puts "Looking for coupons..."
      @result = get_coupons
      @result.each {|coupon| send_to_of(coupon)}
      if @count > 0
        puts "Sent #{@count} coupons to OmniFocus"
      else
        puts "No new coupons found."
      end
      # puts "Sending extra bucks to card"
      # send_bucks_to_card
      # puts "Done"
      # exit
    end

  end
end
