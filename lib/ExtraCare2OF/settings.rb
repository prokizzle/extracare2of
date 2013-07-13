module ExtraCare2OF
  class Settings
    attr_reader :debug

    def initialize(args)
      @username = args[:username]
    end

  end
end
