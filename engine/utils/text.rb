require "engine/rendering/image_sheet"

class Text
  @@font = nil
  @@window = nil
  @@lines = Hash.new
  @@bubble_texture = nil
  @@font_size = 16

  def self.window= obj
    @@window = obj
  end

  def self.font= path
    @@font = path
  end

  def self.[] text
    if @@lines[text] == nil
      @@lines[text] = Gosu::Image.from_text @@window, text, @@font, @@font_size
    end
    @@lines[text]
  end

  def self.draw lines, x, y, c = 0xff000000, z = 1
    tmp = 0
    lines.each do |line|
      Text[line].draw x, y + tmp, z, 1, 1, c
      tmp += (@@font_size).round
    end
  end
  def self.draw_bubble lines, pos_x, pos_y, width, height, camera
    #puts "begin"
    if @@bubble_texture == nil
      @@bubble_texture = ImageSheet.new(
        File.join('res', 'images', 'speech_bubble.png'),
        @@font_size, @@font_size, :z_index => 0.9999
        )
    end
    start_x = pos_x - width / 2 - @@font_size
    start_y = pos_y - height - @@font_size
    max_x = start_x + width + @@font_size * 2
    max_y = start_y + height + @@font_size * 2
    (start_x..max_x).step @@font_size do |x|
      @@bubble_texture.tile_x = (x <= start_x) ? 0 : (x < max_x) ? 1 : 2
      @@bubble_texture.pos_x = x
      (start_y..max_y).step @@font_size do |y|
        @@bubble_texture.tile_y = (y <= start_y) ? 0 : (y < max_y) ? 1 : 2
        @@bubble_texture.pos_y = y
        @@bubble_texture.draw camera
      end
    end
    @@bubble_texture.tile_x = 1
    @@bubble_texture.tile_y = 3
    @@bubble_texture.pos_x = (start_x + max_x) / 2
    @@bubble_texture.tile_y = 3
    @@bubble_texture.draw camera
    self.draw lines, start_x + @@font_size, start_y + @@font_size
  end
end
