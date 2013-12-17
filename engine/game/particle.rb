require "engine/game/entity"

module Engine
  module Game
    class Particle < Entity
      attr_accessor :time_remaining
      attr_accessor :explodes_on_contact

      def initialize pos_x, pos_y, width, height, options = Hash.new
        super pos_x, pos_y, width, height, options

        self.time_remaining = options[:duration].nil? ? 0 : options[:duration]
        self.explodes_on_contact = options[:explodes_on_contact].nil? ? true : options[:explodes_on_contact]
      end

      def update delta, world
        super delta, world
        self.time_remaining -= delta
        if self.time_remaining < 0
          self.die world
        end
      end

      def react_to_collision sender, col, world
        super sender, col, world

        if self.explodes_on_contact
          self.die world
        end
      end
    end
  end
end
