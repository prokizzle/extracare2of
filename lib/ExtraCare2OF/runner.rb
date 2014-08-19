
module ExtraCare2OF
  class Runner

    def initialize(args)
      @username = args[:username]
      @password = args[:password]
      @db       = ExtraCare2OF::Database.new(username: @username)
      @browser  = ExtraCare2OF::Authentication.new(username: @username, password: @password)
      @settings = Settings.new
      @browser.login
      @count = 0
      # p @rewards_source
    end

    def async_response(url)
      request_id = Time.now.to_i
      @browser.request(url, request_id)
      until @browser.hash[request_id][:ready]
        sleep 0.1
      end
      @browser.hash[request_id]
    end

    # [fix] - rewards scanner not picking up all deals
    # [todo] - add extrabucks support
    def get_coupons
      @rewards_source = async_response("https://m.cvs.com/mt/www.cvs.com/extracare/landing.jsp")[:body]
      if $debug
        puts @rewards_source
        exit
      end
      @deals_array = Array.new
      rewards = @rewards_source.scan(/<div class="un_exEntry">\n.+\>(.+)\<.div><.div.+$\n.+\>(.+)\<.div.+$\n.+\>(.+)\<.div.+$\n.+$/)
      rewards.each do |deal|
        name = deal[0]
        due_date = deal[1]
        note = deal[2]
        # defer_date = deal[3]
        @deals_array.push({:name => name,:due_date => parse_date(due_date), :defer_date => Time.now, :note => note})
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

    def process_coupon(coupon)
      # puts " - Sending #{get_coupons.size} tasks to OF"
      unless @db.coupon_exists?(coupon[:name])
        @db.add_coupon(name: coupon[:name], due_date: coupon[:due_date], defer_date: coupon[:defer_date])
        puts "----"
        puts " Title: #{coupon[:name]}"
        puts " - Due Date: #{coupon[:due_date]}"
        puts " - Start Date: #{coupon[:defer_date]}"
        puts " - Note: #{coupon[:note]}"
        CreateTask::OmniFocus.new(coupon.to_hash) if @settings.use_omnifocus
        CreateTask::Reminders.new(coupon.to_hash) if @settings.use_reminders
        CreateTask::Things.new(coupon.to_hash) if @settings.use_things
        CreateTask::DueApp.new(coupon.to_hash) if @settings.use_dueapp
        # Services::Reminders.new(coupon.to_hash)
      end
    end


    def run
      puts "Looking for coupons..."
      @result = get_coupons
      @result.each {|coupon| process_coupon(coupon)}
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
