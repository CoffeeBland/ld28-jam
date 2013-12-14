require $engineDir + '/utils/aabb'

class Camera < AABB
  def center_on entity
    self.pos_x = entity.pos_x + entity.width / 2 - self.width / 2
    self.pos_y = entity.pos_y + entity.height / 2 - self.height / 2
  end
end
