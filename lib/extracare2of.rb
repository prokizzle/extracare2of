require 'yaml'
require 'highline/import'
require 'appscript';include Appscript
require 'amatch';include Amatch
require 'chronic'
require 'mechanize'
require 'open-uri'

module ExtraCare2OF
    Dir[File.dirname(__FILE__) + '/extracare2of/*.rb'].each do |file|
    require file
  end
end