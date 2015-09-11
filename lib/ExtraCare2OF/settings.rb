module ExtraCare2OF
  class Settings
    attr_reader :debug, :use_omnifocus, :use_reminders, :use_things, :use_dueapp

    def initialize
      @filename      = "#{ENV['HOME']}/.extracare2of/config/config.yml"
      unless File.exists?(@filename)
        config = {services: {
                    :use_omnifocus => true,
                    :use_reminders => false,
                    :use_things => false,
                    :use_dueapp => false
                  }
                  }
        File.open(@filename, "w") do |f|
          f.write(config.to_yaml)
        end
      end
      @settings = YAML.load_file(@filename)
      @use_omnifocus = @settings[:services][:use_omnifocus]
      @use_reminders = @settings[:services][:use_reminders]
      @use_things = @settings[:services][:use_things]
      @use_dueapp = @settings[:services][:use_dueapp]
    end

  end
end
