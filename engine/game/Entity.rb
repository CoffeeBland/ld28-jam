require $engineDir + '/game/collisionnable'

class Entity < Collisionnable
  attr_accessor :image_sheet
  attr_accessor :image_sheet_offset_x
  attr_accessor :image_sheet_offset_y
  def health
    @health
  end
  def health= value
    @health = value.keys[0]
    if (@health < 0)
      self.die value.values[0]
    end
  end

  def should_be_removed
    @should_be_removed
  end
  def remove
    @should_be_removed = true
  end

  def initialize pos_x, pos_y, width, height, options = Hash.new
    super pos_x, pos_y, width, height, options
    self.image_sheet = options[:image_sheet].nil? ? nil : options[:image_sheet]
    self.image_sheet_offset_x = options[:image_sheet_offset_x].nil? ? nil : options[:image_sheet_offset_x]
    self.image_sheet_offset_y = options[:image_sheet_offset_y].nil? ? nil : options[:image_sheet_offset_y]
    self.health = options[:health].nil? ? [0 => options[:world]] : [options[:health] => options[:world]]
    @should_be_removed = false
  end

  def die
    self.remove
  end

  def drawable?
    self.image_sheet != nil && self.image_sheet_offset_x != nil && self.image_sheet_offset_y != nil
  end

  def hit_for damage
  	self.health -= damage
  end

  def update delta, world
    super delta, world

    if self.drawable?
      self.image_sheet.pos_x = self.pos_x + self.image_sheet_offset_x
      self.image_sheet.pos_y = self.pos_y + self.image_sheet_offset_y
      self.image_sheet.update delta
    end
  end

  def draw camera
    if self.drawable?
      self.image_sheet.draw camera
    end
  end
end
