require $engineDir + '/utils/aabb'

class Collision
  attr_accessor :collision_x
  attr_accessor :collision_y

  attr_accessor :distance_x
  attr_accessor :distance_y

  attr_accessor :in_collision_top
  attr_accessor :in_collision_left
  attr_accessor :in_collision_right
  attr_accessor :in_collision_bottom

  def initialize distance_x, distance_y
    self.distance_x = distance_x
    self.distance_y = distance_y
    self.in_collision_top = false
    self.in_collision_bottom = false
    self.in_collision_left = false
    self.in_collision_right = false
  end
end

class Collisionnable < AABB
  DISTANCE_TOLERANCE = 0.001
  STEP_MAXIMUM = 8

  attr_accessor :is_frictionnal
  attr_accessor :gravitates
  attr_accessor :collides
  attr_accessor :can_be_collided

  attr_accessor :friction_factor
  attr_accessor :rebound_factor

  attr_accessor :angle

  attr_accessor :velocity_x
  attr_accessor :velocity_y
  attr_accessor :has_moved

  attr_accessor :last_collision

  def initialize pos_x, pos_y, width, height, options = Hash.new
    super pos_x, pos_y, width, height
    self.is_frictionnal = options[:is_frictionnal].nil? ? true : options[:is_frictionnal]
    self.gravitates = options[:gravitates].nil? ? true : options[:gravitates]
    self.collides = options[:collides].nil? ? true : options[:collides]
    self.can_be_collided = options[:can_be_collided].nil? ? true : options[:can_be_collided]

    self.friction_factor = options[:friction_factor].nil? ? 0 : options[:friction_factor]
    self.rebound_factor = options[:rebound_factor].nil? ? 0 : options[:rebound_factor]

    self.angle = options[:angle].nil? ? :none : options[:angle]

    self.velocity_x = 0
    self.velocity_y = 0
    self.has_moved = false
  end

  def aabb
    AABB.new self.pos_x + [self.velocity_x, 0].min,
      self.pos_y + [self.velocity_y, 0].min,
      self.width + self.velocity_x.abs,
      self.height + self.velocity_y.abs
  end
  def in_collision? world, pos_x, pos_y
    set = world.spatial_map.get aabb.new pos_x, pos_y, self.width, self.height
    set.delete self
    set.each do |entity|
      if entity.can_be_collided
        case entity.angle
        when :none
          return true
        when :diagonal_tl_br
          cornerX = self.pos_x - entity.pos_x
          cornerY = self.pos_y + self.height - entity.pos_y
          if  cornerX < 0 ||
              cornerY > entity.height ||
              cornerX < entity.width &&
              cornerY > 0 &&
              entity.height / entity.width * cornerX - cornerY < 0
            return true
          end
        when :diagonal_tr_bl
          cornerX = self.pos_x + self.width - entity.pos_x
          cornerY = self.pos_y + self.height - entity.pos_y
          if  cornerX > entity.width ||
              cornerY > entity.height ||
              cornerX > 0 &&
              cornerY > 0 &&
              -entity.height / entity.width * cornerX + entity.height - cornerY < 0
            return true
          end
        end
      end
    end
    false
  end
  def in_collision? entity, positionX, positionY
    entity.can_be_collided &&
    xAligned?(entity, positionX, positionY) &&
    yAligned?(entity, positionX, positionY)
  end
  def xAligned? entity, positionX, positionY
    positionX - entity.pos_x + entity.width < DISTANCE_TOLERANCE &&
    positionX + self.width - entity.pos_x > -DISTANCE_TOLERANCE
  end
  def yAligned? entity, positionX, positionY
    positionY - entity.pos_y + entity.height < DISTANCE_TOLERANCE &&
    positionY + self.height - entity.pos_y > -DISTANCE_TOLERANCE
  end

  def determineCollision entity, velocity_x, velocity_y
    case self.angle
    when :none
      determineStraightCollision? entity, velocity_x, velocity_y
    when :diagonal_tl_br
      if self.pos_x <= entity.pos_x ||
          self.pos_y >= (entity.pos_y + entity.height)
        determineStraightCollision entity, velocity_x, velocity_y
      end
      determine entity, velocity_x, velocity_y
    when :diagonal_tr_bl
    end
  end
  def determineStraightCollision entity, velocity_x, velocity_y
    col = Collision.new velocity_x, velocity_y

    if velocity_x > 0
      tmpX = entity.pos_x - self.pos_x - self.width
      tmpY = velocity_y * tmpX / velocity_x
      if tmpX > -DISTANCE_TOLERANCE &&
          tmpX < velocity_x &&
          self.yAligned?(entity, pos_x + tmpX, pos_y + tmpY)
        col.distance_x = tmpX
        col.in_collision_right = true
        col.collision_x = entity
      end
    elsif velocity_x < 0
      tmpX = entity.pos_x + entity.width - self.pos_x
      tmpY = velocity_y * tmpX / velocity_x
      if tmpX < DISTANCE_TOLERANCE &&
          tmpX > velocity_x &&
          self.yAligned?(entity, pos_x + tmpX, pos_y + tmpY)
        col.distance_x = tmpX
        col.in_collision_left = true
        col.collision_x = entity
      end
    elsif velocity_y > 0
      tmpY = entity.pos_y - self.pos_y - self.height
      tmpX = velocity_x * tmpY / velocity_y
      if tmpY > -DISTANCE_TOLERANCE &&
          tmpY < velocity_y &&
          self.xAligned?(entity, pos_x + tmpX, pos_y + tmpY)
        col.distance_y = tmpY
        col.in_collision_top = true
        col.collision_y = entity
      end
    elsif velocity_y < 0
      tmpY = entity.pos_y + entity.height - self.pos_y
      tmpX = velocity_x * tmpY / velocity_y
      if tmpY < DISTANCE_TOLERANCE &&
          tmpY > velocity_y &&
          self.xAligned?(entity, pos_x + tmpX, pos_y + tmpY)
        col.distance_y = tmpY
        col.in_collision_bottom = true
        col.collision_y = entity
      end
    end
  end
  def determine_tl_br_collision entity, velocity_x, velocity_y
    col = Collision.new velocity_x, velocity_y
    objRatio = entity.height / entity.width
    col.distance_x /= objRatio + 1

    tmp = entity.pos_y + entity.height +
      (objRatio *
      (self.pos_x + col.distance_x -
      (entity.pos_x + entity.width))) -
      self.pos_y + self.height - DISTANCE_TOLERANCE
    if tmp - col.distance_y < DISTANCE_TOLERANCE
      col.distance_y = tmp
      col.collision_y = entity
      col.in_collision_bottom = true
    end
    col
  end
  def determine_tr_bl_collision entity, velocity_x, velocity_y
    col = COllision.new velocity_x, velocity_y
    objRatio = entity.height / entity.width
    col.distance_x /= objRatio + 1

    tmp = entity.pos_y + entity.height -
      (objRatio *
      (self.getpos_x + self.width + col.distance_x - entity.pos_x)) -
      self.pos_y + self.height - DISTANCE_TOLERANCE
    if tmp - col.distance_y < DISTANCE_TOLERANCE
      col.distance_y = tmp
      col.collision_y = entity
      col.in_collision_bottom = true
    end
    col
  end
  def shortestCollision col1, col2
    col = Collision.new 0, 0

    # X axis
    if col1.distance_x > 0 && col2.distance_x < col1.distance_x ||
        col1.distance_x < 0 && col2.distance_x > col.distance_x
      col.distance_x = col2.distance_x
      col.in_collision_left = col2.in_collision_left
      col.in_collision_right = col2.in_collision_right
      col.collision_x = col2.collision_x
    else
      col.distance_x = col1.distance_x
      col.in_collision_left = col1.in_collision_left
      col.in_collision_right = col1.in_collision_right
      col.collision_x = col1.collision_x
    end

    # Y axis
    if col1.distance_y > 0 && col2.distance_y < col1.distance_y ||
        col1.distance_y < 0 && col2.distance_y > col.distance_y
      col.distance_y = col2.distance_y
      col.in_collision_top = col2.in_collision_top
      col.in_collision_bottom = col2.in_collision_bottom
      col.collision_y = col2.collision_y
    else
      col.distance_y = col1.distance_y
      col.in_collision_top = col1.in_collision_top
      col.in_collision_bottom = col1.in_collision_bottom
      col.collision_y = col1.collision_y
    end
    col
  end

  def update delta, world
    self.applyWorldForces world.gravity_x, world.gravity_y, world.air_friction

    col = collision.new self.velocity_x, self.velocity_y

    # If the speed is 0, no need to check collisions
    if self.velocity_x == 0 && self.velocity_y == 0
      self.has_moved = false
      self.last_collision = col
      return
    end

    # Establish collision
    if self.collides
      world.spatial_map.get(self.aabb).each do |entity|
        if entity != self && entity.can_be_collided
          col = self.shortestCollision(col, determineCollision(entity, col.distance_x, col.distance_y))
        end
      end
    end
    positionX = self.positionX + col.distance_x
    positionY = self.positionY + col.distance_y
    if (!in_collision world, positionX, positionY)
      self.pos_x = positionX
      self.pos_y = positionY
    end

    self.resolveCollision col
    self.has_moved = col.distance_x != 0 || col.distance_y != 0
    self.last_collision = col
  end
  def applyWorldForces gravity_x, gravity_y, air_friction
    if self.gravitates
      self.velocity_x += gravity_x
      self.velocity_y += gravity_y
    end
    if self.is_frictionnal
      self.velocity_x *= air_friction
      self.velocity_y *= air_friction
    end
  end

  def resolveCollision col, world
    objsin_collision = Set.new

    # Y-axis
    if col.in_collision_bottom || col.in_collision_top
      objsin_collision.add self
      # If there is an object to react to
      if col.collision_y != null
        objsin_collision.add col.collision_y
        self.velocity_y *= -col.collision_y.rebound_factor
        self.velocity_x *= col.collision_y.friction_factor
      else # Otherwise just kill all speed
        self.velocity_y = 0
      end
    end

    # X-axis
    if col.in_collision_right || col.in_collision_left
      objsin_collision.add self
      # If there is an object to react to
      if col.collision_x != null
        objsin_collision.add col.collision_x
        # Check if there should be a step up to do
        if self.pos_y + self.height - STEP_MAXIMUM <= col.collision_x.pos_y
          tmp = (self.pos_y + self.height - col.collision_x.pos_y).abs
          self.velocity_y = -(tmp + world.gravity_y)
        else # Otherwise resolve the speed normally
          self.velocity_x *= -col.collision_x.rebound_factor
          self.velocity_y *= col.collision_x.friction_factor
        end
      else # Otherwise just kill all speed
        self.velocity_x = 0
      end
    end

    objsin_collision.each do |entity|
      entity.react_to_collision col, world
    end
  end
  def react_to_collision col, world

  end
end
