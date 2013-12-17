require "engine/game/character"
require "engine/game/entity"

module Engine
  module Game
    class Door < Entity
    end

    class GhostDoor < Door
      DOOR_OPTIONS = {
        :gravitates => false, :collides => false,
        :can_be_collided => false, :rebound_factor_y => 0,
      }

      def initialize pos_x, pos_y, width, height, options = Hash.new
        super pos_x, pos_y, width, height, DOOR_OPTIONS.merge(options)
        self.class.send(:define_method, :react_to_character) do |sender, world|
          options[:action].call(sender, world) if sender.is_a?(Character)
        end
      end

    end

    class PhysicalDoor < Door
      DOOR_OPTIONS = {
        :gravitates => false, :collides => false,
        :can_be_collided => true, :rebound_factor_y => 0,
      }

      def initialize pos_x, pos_y, width, height, options = Hash.new
        super pos_x, pos_y, width, height, DOOR_OPTIONS.merge(options)
        self.class.send(:define_method, :react_to_collision) do |sender, col, world|
          options[:action].call(sender, col, world) if sender.is_a?(Character)
        end
      end

    end
  end
end
