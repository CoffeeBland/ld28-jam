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

module Gosu
  class Image
    def draw_centered
      x = (Images.window.width / 2) - (self.width / 2)
      y = (Images.window.height / 2) - (self.height / 2)
      self.draw x, y, 0
    end
  end
end
