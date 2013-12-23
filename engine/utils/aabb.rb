module Engine
  module Utils
    class AABB
      attr_accessor :pos_x
      attr_accessor :pos_y
      attr_accessor :width
      attr_accessor :height
      def left
        pos_x
      end
      def top
        pos_y
      end
      def right
        pos_x + width
      end
      def bottom
        pos_y + height
      end

      def initialize pos_x, pos_y, width, height
        self.pos_x = pos_x
        self.pos_y = pos_y
        self.width = width
        self.height = height
      end
    end
  end
end
