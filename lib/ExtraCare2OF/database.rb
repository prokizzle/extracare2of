require 'sqlite3'

module Extracare2of
  class Database
    attr_accessor :add_user
    attr_reader :add_user

    def initialize
      @handle = `whoami`
      db_path = "#{ENV['HOME']}/.extracare2of/db/coupons.db"
      create_db unless File.exist?(db_path)
      @db = SQLite3::Database.new( db_path )
    end

    def create_db
      `mkdir -p ~/.extracare2of/db`
      `mkdir -p ~/.extracare2of/config`
      `touch ~/.extracare2of/db/coupons.db`
      @db.execute("CREATE TABLE coupons(
        id integer,
        name text,
        due_date integer,
        start_date text,
        handle text,
        PRIMARY KEY(id))")
    end

    def close
      @db.close
    end

    def add_coupon(args)
      name = args[:name].to_s
      due_date = args[:due_date].to_s
      start_date = args[:start_date].to_s
      return false if coupon_exists?(name)
      @db.execute(
        "insert into coupons(
          name, due_date, start_date, handle
          ) values (?,?,?,?)",
        name, due_date, start_date, @handle
      )
    end

    def coupon_exists?(name)
      @db.execute( "select 1 where exists(
            select 1
            from coupons
            where name = ?
        ) ", [name] ).any?
    end
  end
end
