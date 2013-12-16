require "engine/game/collisionnable"

class Entity < Collisionnable
  @@entity_count = 0
  @@entity_count_max = 1000

  attr_accessor :image_sheet
  attr_accessor :image_sheet_offset_x
  attr_accessor :image_sheet_offset_y
  attr_accessor :health
  attr_reader :entity_number

  def should_be_removed
    @should_be_removed
  end
  def remove
    @should_be_removed = true
  end
  def z_index_decal
    if @z_index_decal.nil?
      @z_index_decal = self.entity_number.to_f / @@entity_count_max
      #@z_index_decal = self.entity_number
    end
    @z_index_decal
  end

  def initialize pos_x, pos_y, width, height, options = Hash.new
    super pos_x, pos_y, width, height, options
    self.image_sheet = options[:image_sheet]
    self.image_sheet_offset_x = options[:image_sheet_offset_x].nil? ? 0 : options[:image_sheet_offset_x]
    self.image_sheet_offset_y = options[:image_sheet_offset_y].nil? ? 0 : options[:image_sheet_offset_y]
    self.health = options[:health]
    @should_be_removed = false
    @@entity_count = (@@entity_count + 1) % @@entity_count_max
    @entity_number = @@entity_count
  end

  def die world
    self.remove
  end

  def drawable?
    self.image_sheet != nil && self.image_sheet_offset_x != nil && self.image_sheet_offset_y != nil
  end


  def dead?
    self.health != nil && self.health <= 0
  end
  def hit_for damage, world
    self.health -= damage unless self.health.nil?
    self.die world if self.dead?
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
      self.image_sheet.draw camera, self.z_index_decal
    end
  end
end
