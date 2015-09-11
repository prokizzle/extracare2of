module Extracare2of
  # Model for coupons
  class Coupon

    def self.conn
      db_path = "#{ENV['HOME']}/.extracare2of/db/coupons.db"
      SQLite3::Database.new(db_path)
    end

    def self.exists?(name)
      conn.execute("select 1 where exists(
            select 1
            from coupons
            where name = ?)", [name]).any?
    end

    def self.create(args)
      return false if exists?(name)
      conn.execute(
        "insert into coupons(
          name, due_date, start_date, handle
          ) values (?,?,?,?)",
        args[:name], args[:due_date], args[:start_date], `whoami`
      )
    end
  end
end
