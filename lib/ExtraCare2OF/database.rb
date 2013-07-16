require 'sqlite3'

module ExtraCare2OF
  class Database
    attr_accessor :add_user
    attr_reader :add_user

    def initialize(args)
      @handle = args[ :username]
      open
      # create_tables
      tasks
    end

    def tasks
      begin
        # @db.execute("alter table matches add column emailed integer")
      rescue
      end
    end

    def create_tables
      begin
        @db.execute("CREATE TABLE coupons(
        id integer,
        name text,
        due_date integer,
        start_date text,
        handle text,
        PRIMARY KEY(id)
        )
        ")
      rescue
      end
    end


    def open
      @db = SQLite3::Database.new( "./db/#{@handle}.db" )
    end

    def close
      @db.close
    end

    def add_coupon(args)

      name = args[:name].to_s
      due_date = args[:due_date].to_s
      start_date = args[:start_date].to_s
      unless coupon_exists?(name)
        # begin
        @db.execute("insert into coupons(name, due_date, start_date, handle) values (?,?,?,?)", name, due_date, start_date, @handle)
      end
    end

    def coupon_exists?(name)
      temp = @db.execute( "select 1 where exists(
            select 1
            from coupons
            where name = ?
        ) ", [name] ).any?
    end
  end
end
