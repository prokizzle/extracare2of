# ExtraCare2OF Gem
module Extracare2of
  # Stores Regular Expressions
  class Expressions
    def self.rewards
      return Regexp.new(/<div class="un_exEntry">\n.+\>(.+)\<.div><.div.+$\n.+\>(.+)\<.div.+$\n.+\>(.+)\<.div.+$\n.+$/)
    end
  end
end
