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
    def color
      @color
    end

    def draw_rect x, y, width, height, z = 0, color = @color
      self.draw_quad(
          x,         y,          color,
          x + width, y,          color,
          x,         y + height, color,
          x + width, y + height, color,
        z)
    end

    def draw_rect_outline x, y, width, height, z = 0
      draw_line x, y, @color, x + width, y, @color, z # top
      draw_line x, y + height, @color, x + width, y + height, @color, z # bottom
      draw_line x, y, @color, x, y + height, @color, z # left
      draw_line x + width, y, @color, x + width, y + height, @color, z # right
    end

  end
end
