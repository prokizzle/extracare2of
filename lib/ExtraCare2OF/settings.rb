# Extracare Gem
module Extracare2of
  # Abstraction for reading and writing to config file
  class Settings
    attr_reader :debug, :use_omnifocus, :use_reminders, :use_things, :use_dueapp

    def initialize
      filename = "#{ENV['HOME']}/.extracare2of/config/config.yml"
      create_config(filename)
      settings = YAML.load_file(filename)
      @use_omnifocus = settings[:services][:use_omnifocus]
      @use_reminders = settings[:services][:use_reminders]
      @use_things = settings[:services][:use_things]
      @use_dueapp = settings[:services][:use_dueapp]
    end

    def create_config(filename)
      return false if File.exist?(filename)
      File.open(filename, 'w') do |f|
        f.write(default_config.to_yaml)
      end
    end

    def default_config
      { services:
        { use_omnifocus: true,
          use_reminders: false,
          use_things: false,
          use_dueapp: false }
        }.to_yaml
    end
  end
end
