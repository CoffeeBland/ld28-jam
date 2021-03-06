require "engine/game/actor"
require "ld28/weapons"

module LD28
  module Characters
    class Hero < Actor
      def initialize pos_x, pos_y, width, height, options = Hash.new
        super pos_x, pos_y, width, height, options
        self.weapon = IronSword.new
      end
    end
  end
end
