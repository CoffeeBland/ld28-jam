module Engine
  module Rendering
    class Images
      @@images = Hash.new
      @@window = nil

      def self.window
        @@window
      end
      def self.window= obj
        @@window = obj
      end

      def self.[] key
        @@images[key]
      end

      def self.[]= key, path
        @@images[key] = Gosu::Image.new(@@window, path, false)
      end

      def self.add key, val
        @@images[key] = val
      end
    end
  end
end

module Gosu
  class Image
    def draw_centered
      x = (Images.window.width / 2) - (self.width / 2)
      y = (Images.window.height / 2) - (self.height / 2)
      self.draw x, y, 0
    end
    def self.load_tiles_square window, source, tw, th, tileable
      img = Image.new window, source
      tmp_tiles = load_tiles window, img, tw, th, tileable

      tiles_x = img.width / tw
      tiles_y = img.height / th
      tiles = Array.new

      for x in 0...tiles_x
        tiles[x] = Array.new
        for y in 0...tiles_y
          tiles[x][y] = tmp_tiles[x + y * tiles_x]
        end
      end
      tiles
    end
  end
end
