require "gosu"

module Gosu
  class Window

    def set_color color
      if color.is_a? Gosu::Color
        @color = color
      else
        @color = Gosu::Color.rgba(color)
      end
    end

    def draw_rect x, y, width, height, z = 0
      self.draw_quad(
          x,         y,          @color,
          x + width, y,          @color,
          x,         y + height, @color,
          x + width, y + height, @color,
        z)
    end

  end
end
