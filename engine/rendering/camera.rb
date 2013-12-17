require "engine/utils/aabb"

module Engine
  module Rendering
    class Camera < AABB
      attr_accessor :decal_x
      attr_accessor :decal_y

      def pos_x
        super + self.decal_x
      end
      def pos_y
        super + self.decal_y
      end

      def initialize pos_x, pos_y, width, height
        super pos_x, pos_y, width, height
        self.decal_x = 0
        self.decal_y = 0
      end

      def reset_decals
        self.decal_x = 0
        self.decal_y = 0
      end

      def center_on entity
        new_x = entity.pos_x + entity.width / 2 - self.width / 2
        new_y = entity.pos_y + entity.height / 2 - self.height / 2
        pos_x = self.pos_x - self.decal_x
        pos_y = self.pos_y - self.decal_y
        diff_x = new_x - pos_x
        diff_y = new_y - pos_y
        self.pos_x = pos_x + diff_x * 0.1
        self.pos_y = pos_y + diff_y * 0.1
      end

      def update delta
      end
    end
  end
end
