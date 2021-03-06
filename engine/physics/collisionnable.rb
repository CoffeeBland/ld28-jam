require 'engine/utils/aabb'
include Engine::Utils

module Engine
  module Physics
    class Collision
      attr_accessor :collision_x
      attr_accessor :collision_y

      attr_accessor :distance_x
      attr_accessor :distance_y

      attr_accessor :in_collision_top
      attr_accessor :in_collision_left
      attr_accessor :in_collision_right
      attr_accessor :in_collision_bottom

      def initialize(distance_x, distance_y)
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

      attr_accessor :friction_factor_x
      attr_accessor :friction_factor_y
      attr_accessor :rebound_factor_x
      attr_accessor :rebound_factor_y

      attr_accessor :angle

      attr_accessor :velocity_x
      attr_accessor :velocity_y
      attr_accessor :has_moved

      attr_accessor :last_collision

      def initialize(pos_x, pos_y, width, height, options = Hash.new)
        super pos_x, pos_y, width, height
        self.is_frictionnal = options[:is_frictionnal].nil? ? true : options[:is_frictionnal]
        self.gravitates = options[:gravitates].nil? ? true : options[:gravitates]
        self.collides = options[:collides].nil? ? true : options[:collides]
        self.can_be_collided = options[:can_be_collided].nil? ? true : options[:can_be_collided]

        self.friction_factor_x = options[:friction_factor_x].nil? ? 0.5 : options[:friction_factor_x]
        self.friction_factor_y = options[:friction_factor_y].nil? ? 1 : options[:friction_factor_y]
        self.rebound_factor_x = options[:rebound_factor_x].nil? ? 0.5 : options[:rebound_factor_x]
        self.rebound_factor_y = options[:rebound_factor_y].nil? ? 0.5 : options[:rebound_factor_y]

        self.angle = options[:angle].nil? ? :none : options[:angle]

        self.velocity_x = 0.0
        self.velocity_y = 0.0
        self.has_moved = false
        self.last_collision = Collision.new 0, 0
      end

      def aabb
        AABB.new self.pos_x + [self.velocity_x, 0].min,
          self.pos_y + [self.velocity_y, 0].min,
          self.width + self.velocity_x.abs,
          self.height + self.velocity_y.abs
      end
      def in_collision_world?(world, pos_x, pos_y)
        world.spatial_map.
            get(AABB.new pos_x, pos_y, self.width, self.height).
            delete(self).
            each do |entity|
          if self.in_collision_entity?(entity, pos_x, pos_y)
            case entity.angle
            when :none
              return true
            when :diagonal_tl_br
              corner_x = self.pos_x - entity.pos_x
              corner_y = self.bottom - entity.pos_y
              if (corner_x < 0 ||
                  corner_y > entity.height)
                #re turn true
              end
            when :diagonal_tr_bl
              corner_x = self.right - entity.pos_x
              corner_y = self.bottom - entity.pos_y
              if (corner_x > entity.width ||
                  corner_y > entity.height)
                #return true
              end
            else
              return true
            end
          end
        end
        false
      end
      def in_collision_entity?(entity, position_x, position_y)
        entity.can_be_collided &&
        position_x - entity.right < 0 &&
        position_x + self.width - entity.pos_x > 0 &&
        position_y - entity.bottom < 0 &&
        position_y + self.height - entity.pos_y > 0
      end
      def overlaps?(entity)
        self.x_aligned?(entity, self.pos_x, self.pos_y) &&
        self.y_aligned?(entity, self.pos_x, self.pos_y)
      end
      def x_aligned?(entity, position_x, position_y)
        position_x - entity.right < DISTANCE_TOLERANCE &&
        position_x + self.width - entity.pos_x > -DISTANCE_TOLERANCE
      end
      def y_aligned?(entity, position_x, position_y)
        position_y - entity.bottom < DISTANCE_TOLERANCE &&
        position_y + self.height - entity.pos_y > -DISTANCE_TOLERANCE
      end

      def determine_collision(entity, velocity_x, velocity_y)
        case entity.angle
          when :none
            self.determine_straight_collision entity, velocity_x, velocity_y
          when :diagonal_tl_br
            if (self.left <= entity.left && self.bottom >= (entity.top + STEP_MAXIMUM)) ||
                self.top >= entity.bottom
              self.determine_straight_collision entity, velocity_x, velocity_y
            else
              self.determine_tl_br_collision entity, velocity_x, velocity_y
            end
          when :diagonal_tr_bl
            if (self.right >= entity.right && self.bottom >= (entity.top + STEP_MAXIMUM)) ||
                self.top >= entity.bottom
              self.determine_straight_collision entity, velocity_x, velocity_y
            else
              self.determine_tr_bl_collision entity, velocity_x, velocity_y
            end
          else
            self.determine_straight_collision entity, velocity_x, velocity_y
        end
      end
      def determine_straight_collision(entity, velocity_x, velocity_y)
        col = Collision.new velocity_x, velocity_y

        # Going right
        if velocity_x > 0
          tmp_x = entity.left - self.right # Distance to collision
          tmp_y = velocity_y * (tmp_x / velocity_x) # Scale the vertical distance

          if tmp_x > -DISTANCE_TOLERANCE && tmp_x < velocity_x &&
              self.y_aligned?(entity, pos_x + tmp_x, pos_y + tmp_y)
            col.distance_x = tmp_x
            col.distance_y = tmp_y
            col.in_collision_right = true
            col.collision_x = entity
          end
        # Going left
        elsif velocity_x < 0
          tmp_x = entity.right - self.left # Distance to collision
          tmp_y = velocity_y * (tmp_x / velocity_x) # Scale the vertical distance

          if tmp_x < DISTANCE_TOLERANCE && tmp_x > velocity_x &&
              self.y_aligned?(entity, pos_x + tmp_x, pos_y + tmp_y)
            col.distance_x = tmp_x
            col.distance_y = tmp_y
            col.in_collision_left = true
            col.collision_x = entity
          end
        end
        # Going down
        if velocity_y > 0
          tmp_y = entity.top - self.bottom # Distance to collision
          tmp_x = velocity_x * (tmp_y / velocity_y) # Scale the horizontal distance

          if tmp_y > -DISTANCE_TOLERANCE && tmp_y < velocity_y &&
              self.x_aligned?(entity, pos_x + tmp_x, pos_y + tmp_y)
            col.distance_y = tmp_y
            col.in_collision_bottom = true
            col.collision_y = entity
          end
        # Going up
        elsif velocity_y < 0
          tmp_y = entity.bottom - self.top # Distance to collision
          tmp_x = velocity_x * (tmp_y / velocity_y) # Scale the horizontal distance

          if tmp_y < DISTANCE_TOLERANCE && tmp_y > velocity_y &&
              self.x_aligned?(entity, pos_x + tmp_x, pos_y + tmp_y)
            col.distance_y = tmp_y
            col.in_collision_top = true
            col.collision_y = entity
          end
        end

        col
      end
      def determine_tl_br_collision(entity, velocity_x, velocity_y)
        col = Collision.new velocity_x, velocity_y
        obj_ratio = entity.height.to_f / entity.width

        if self.left < entity.left
          tmp = entity.top - self.bottom
        else
          col.distance_x /= obj_ratio + 1
          tmp = entity.bottom +
            (obj_ratio * (self.left + col.distance_x - entity.right)) -
            self.bottom - DISTANCE_TOLERANCE
        end

        if tmp - col.distance_y < STEP_MAXIMUM
          col.distance_y = tmp
          col.collision_y = entity
          col.in_collision_bottom = true
        end
        col
      end
      def determine_tr_bl_collision(entity, velocity_x, velocity_y)
        col = Collision.new velocity_x, velocity_y
        obj_ratio = entity.height.to_f / entity.width

        if self.right > entity.right
          tmp = entity.top - self.bottom
        else
          col.distance_x /= obj_ratio + 1
          tmp = entity.bottom -
            (obj_ratio * (self.right + col.distance_x - entity.left)) -
            self.bottom - DISTANCE_TOLERANCE
        end

        if tmp - col.distance_y < STEP_MAXIMUM
          col.distance_y = tmp
          col.collision_y = entity
          col.in_collision_bottom = true
        end
        col
      end

      def shortest_collision(col1, col2)
        col = Collision.new 0, 0

        # X axis
        if col1.distance_x > 0 && col2.distance_x < col1.distance_x ||
            col1.distance_x < 0 && col2.distance_x > col1.distance_x
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
            col1.distance_y < 0 && col2.distance_y > col1.distance_y
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

      def update(delta, world)
        self.apply_world_forces world.gravity_x, world.gravity_y, world.air_friction

        col = Collision.new self.velocity_x, self.velocity_y

        # If the speed is 0, no need to check collisions
        if self.velocity_x == 0 && self.velocity_y == 0
          self.has_moved = false
          self.last_collision = col
          return
        end

        # Establish collision
        if self.collides
          world.spatial_map.get(self.aabb).delete(self).each do |entity|
            if entity.can_be_collided #&&
                #self.in_collision_entity?(entity, self.pos_x + col.distance_x, self.pos_y + col.distance_y)
              col = self.shortest_collision(col, self.determine_collision(entity, col.distance_x, col.distance_y))
            end
          end
        end

        # Determine new position after collision
        position_x = self.pos_x + col.distance_x
        position_y = self.pos_y + col.distance_y

        # Move, unless this would result in a collision (final ugly check)
        unless self.collides && in_collision_world?(world, position_x, position_y)
          self.pos_x = position_x
          self.pos_y = position_y
        end

        self.resolve_collision col, world
        self.has_moved = col.distance_x != 0 || col.distance_y != 0
        self.last_collision = col
      end
      def apply_world_forces(gravity_x, gravity_y, air_friction)
        if self.gravitates
          self.velocity_x += gravity_x
          self.velocity_y += gravity_y
        end
        if self.is_frictionnal
          self.velocity_x *= air_friction
          self.velocity_y *= air_friction
        end
      end

      def resolve_collision(col, world)
        objs_in_collision = Set.new

        # Y-axis
        if col.in_collision_bottom || col.in_collision_top
          objs_in_collision.add self
          # If there is an object to react to
          if col.collision_y != nil
            objs_in_collision.add col.collision_y
            self.velocity_y *= -col.collision_y.rebound_factor_y
            self.velocity_x *= col.collision_y.friction_factor_x
          else # Otherwise just kill all speed
            self.velocity_y = 0
          end
        end

        # X-axis
        if col.in_collision_right || col.in_collision_left
          objs_in_collision.add self
          # If there is an object to react to
          if col.collision_x != nil
            objs_in_collision.add col.collision_x
            # Check if there should be a step up to do
            if self.bottom - STEP_MAXIMUM <= col.collision_x.pos_y
              tmp = Math.sqrt((self.bottom - col.collision_x.pos_y).abs)
              self.velocity_y = -(tmp + world.gravity_y * 2)
            else # Otherwise resolve the speed normally
              self.velocity_x *= -col.collision_x.rebound_factor_x
              self.velocity_y *= col.collision_x.friction_factor_y
            end
          else # Otherwise just kill all speed
            self.velocity_x = 0
          end
        end

        objs_in_collision.each do |entity|
          entity.react_to_collision self, col, world
        end
      end
      def react_to_collision(sender, col, world)
      end
    end
  end
end
