require 'yaml'
require 'highline/import'
require 'appscript'
include Appscript
require 'amatch'
include Amatch
require 'chronic'
require 'mechanize'
require 'open-uri'
require 'create_task'

# Requires all gem files
module Extracare2of
  Dir[File.dirname(__FILE__) + '/extracare2of/*.rb'].each do |file|
    require file
  end
end
