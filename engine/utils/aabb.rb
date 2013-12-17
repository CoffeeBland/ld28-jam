module Engine
  module Utils
    class AABB
      attr_accessor :pos_x
      attr_accessor :pos_y
      attr_accessor :width
      attr_accessor :height

      def initialize pos_x, pos_y, width, height
        self.pos_x = pos_x
        self.pos_y = pos_y
        self.width = width
        self.height = height
      end
    end
  end
end
