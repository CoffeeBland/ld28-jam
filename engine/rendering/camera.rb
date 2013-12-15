require "engine/utils/aabb"

class Camera < AABB
  attr_accessor :decal_x
  attr_accessor :decal_y

  def pos_x
    super + self.decal_x
  end
  def pos_y
    super + self.decal_y
  end

  def initialize pos_x, pos_y, width, height
    super pos_x, pos_y, width, height
    self.decal_x = 0
    self.decal_y = 0
  end

  def center_on entity
    self.pos_x = entity.pos_x + entity.width / 2 - self.width / 2
    self.pos_y = entity.pos_y + entity.height / 2 - self.height / 2
  end

  def update delta
  end
end
