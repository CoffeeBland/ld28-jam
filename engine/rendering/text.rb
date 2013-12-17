require "engine/rendering/image_sheet"
require "engine/utils/z"

class Text
  @@font = nil
  @@window = nil
  @@lines = Hash.new
  @@bubble_texture = nil
  @@font_size = 20
  @@z_speech = Z[:ui_speech_bubbles]
  @@z_name = Z[:ui_nameplates]

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

  def self.draw lines, x, y, z_decal = 0, z = @@z_speech, c = 0xff000000
    tmp = 0
    lines.each do |line|
      Text[line].draw x, y + tmp, z + z_decal, 1, 1, c
      tmp += (@@font_size).round
    end
  end
  def self.draw_name entity, camera, z_decal = 0, z = @@z_name, c = 0xff000000
    line = Text[entity[:name]]
    x = entity.pos_x + (entity.width / 2 - line.width / 2) - camera.pos_x
    y = entity.pos_y - (entity.image_sheet.height - entity.height) - @@font_size * 1.2 - camera.pos_y
    line.draw x, y, z + z_decal, 1, 1, c
  end
  def self.draw_bubble lines, pos_x, pos_y, camera, z_decal = 0
    width = 0
    lines.each do |line|
      width = [Text[line].width, width].max
    end
    line_dif = width
    width = (width.to_f / @@font_size).ceil * @@font_size
    line_dif = width - line_dif
    height = lines.length * @@font_size

    if @@bubble_texture == nil
      @@bubble_texture = ImageSheet.new(
        File.join('res', 'images', 'speech_bubble.png'),
        @@font_size, @@font_size, :z_index => @@z_speech
        )
    end
    start_x = pos_x - width / 2 - @@font_size #* 0.5
    start_y = pos_y - height - @@font_size * 2
    max_x = start_x + width + @@font_size
    max_y = start_y + height + @@font_size

    (start_x..max_x).step @@font_size do |x|
      @@bubble_texture.tile_x = (x <= start_x) ? 0 : (x < max_x) ? 1 : 2
      @@bubble_texture.pos_x = x
      (start_y..max_y).step @@font_size do |y|
        @@bubble_texture.tile_y = (y <= start_y) ? 0 : (y < max_y) ? 1 : 2
        @@bubble_texture.pos_y = y
        @@bubble_texture.draw camera, z_decal
      end
    end
    @@bubble_texture.tile_x = 1
    @@bubble_texture.tile_y = 3
    @@bubble_texture.pos_x = (start_x + max_x) / 2
    @@bubble_texture.tile_y = 3
    @@bubble_texture.draw camera, z_decal

    self.draw(lines,
        start_x - camera.pos_x + @@font_size + line_dif / 2,
        start_y - camera.pos_y + @@font_size,
        z_decal
      )
  end
end
