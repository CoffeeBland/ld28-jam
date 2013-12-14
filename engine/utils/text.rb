class Text
  @@font = nil
  @@window = nil
  @@lines = Hash.new

  def self.window= obj
    @@window = obj
  end

  def self.font= path
    @@font = path
  end

  def self.[] text
    if @@lines[text] == nil
      @@lines[text] = Gosu::Image.from_text @@window, text, @@font, 16
    end
    @@lines[text]
  end

  def self.draw lines, x, y, c = 0x000000ff, z = 1
    tmp = 0
    lines.each do |line|
      Text[line].draw x, y + tmp, z, 1, 1, c
      tmp += (16).round
    end
  end
end
