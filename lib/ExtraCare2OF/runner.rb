# Extracare2of Gem
module Extracare2of
  # Handles main logic of fetching, storing, and sending coupon data
  class Runner
    def initialize
      @db       = Extracare2of::Database.new
      @browser  = Extracare2of::Authentication.new
      @settings = Settings.new
      @count = 0
      @deals_array = []
    end

    def init
      @browser.authenticate
    end

    def response(url)
      request_id = Time.now.to_i
      @browser.request(url, request_id)
      until @browser.hash[request_id][:ready]
        sleep 1
      end
      puts @browser.hash
      @browser.hash[request_id]
    end

    def fetch_coupons_page
      url = 'https://m.cvs.com/mt/www.cvs.com/extracare/landing.jsp'
      response(url)[:body]
    end

    # [fix] - rewards scanner not picking up all deals
    # [todo] - add extrabucks support
    def coupons
      fetch_coupons_page.scan(/<div class="un_exEntry">\n.+\>(.+)\<.div><.div.+$\n.+\>(.+)\<.div.+$\n.+\>(.+)\<.div.+$\n.+$/).each do |deal|
        @deals_array.push(
          name: deal[0], due_date: parse_date(deal[1]),
          defer_date: Time.now, note: deal[2]
        )
      end
      puts fetch_coupons_page.scan(/<div class="un_exEntry">\n.+\>(.+)\<.div><.div.+$\n.+\>(.+)\<.div.+$\n.+\>(.+)\<.div.+$\n.+$/)
      @deals_array
    end

    def verbose_coupon_task(coupon)
      puts '----'
      puts " Title: #{coupon[:name]}"
      puts " - Due Date: #{coupon[:due_date]}"
      puts " - Start Date: #{coupon[:defer_date]}"
      puts " - Note: #{coupon[:note]}"
    end

    def process_coupon(coupon)
      return false if @db.coupon_exists?(coupon[:name])
      Coupon.create(coupon)
      verbose_coupon_task(coupon)
      CreateTask::Helper.new_task(coupon, task_app)
    end

    def task_app
      return 'omnifocus' if @settings.use_omnifocus
      return 'things' if @settings.use_things
      return 'reminders' if @settings.use_reminders
      return 'dueapp' if @settings.use_dueapp
    end

    def default_parsed_date(datestring)
      Chronic.parse(
        datestring.to_s,
        context: :future, ambiguous_time_range: 8
      )
    end

    def parse_date(datestring)
      return default_parsed_date(datestring) unless datestring =~ /^\+(\d+)$/
      days = (60 * 60 * 24 * Regexp.last_match[1].to_i)
      Time.now + days
    end

    def run
      puts 'Looking for coupons...'
      coupons.select { |coupon| process_coupon(coupon) }
      csize = coupons.size
      puts "Found #{coupons.size} coupons."
    end
  end
end
