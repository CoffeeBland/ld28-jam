require "engine/game/entity"
require "engine/utils/text"

class Character < Entity
  @@default_still_anim = 0
  @@default_speech_anim = 1
  @@default_walk_anim = 2
  @@default_jump_anim = 5
  @@damaged_duration = 800
  @@red_duration = 700
  @@damaged_flash_duration = 100

  attr_reader :current_action
  attr_accessor :update_anim
  attr_accessor :facing
  attr_accessor :landed
  attr_accessor :damaged_duration

  def initialize pos_x, pos_y, width, height, options = Hash.new
    super pos_x, pos_y, width, height, options
    self.update_anim = options[:update_anim] unless options[:update_anim].nil?
    self.facing = :left
    self.landed = false
    self.damaged_duration = 0
    @attributes = Hash.new
  end

  def [] key
    @attributes[key]
  end
  def []= key, value
    @attributes[key] = value
  end

  def hit_for damage, world
    super damage, world
    self.damaged_duration = @@damaged_duration
    self.image_sheet.color = 0xffff0000
  end

  def say speech
    @speech = speech
  end
  def speech
    @speech
  end

  def do action
    @current_action = action
  end

  def update delta, world
    self.landed = false

    if self.damaged_duration > 0
      self.damaged_duration -= delta
      self.image_sheet.color = 0xffffffff if self.damaged_duration <= @@red_duration
    end

    if self.current_action != nil
      self.current_action.update delta, world, self
      @current_action = nil if self.current_action.completed?
    end

    touched_ground = self.last_collision.in_collision_bottom
    super delta, world
    if !touched_ground && self.last_collision.in_collision_bottom
      self.landed = true
    end

    if self.update_anim != nil
      self.update_anim.call self
    else #if there is no sheet, assume that it is citizen
      if self.current_action == nil
        self.image_sheet.tile_y = self.speech.nil? ?  @@default_still_anim :  @@default_speech_anim
        if self.last_collision.in_collision_bottom
          if !self.velocity_x.between?(
              -Collisionnable::DISTANCE_TOLERANCE,
              Collisionnable::DISTANCE_TOLERANCE
              )
            self.image_sheet.tile_y = @@default_walk_anim
          end
          if self.landed
            world.add Smoke.new(self.pos_x + self.width / 2, self.pos_y + self.height)
          end
        else
          self.image_sheet.tile_y = @@default_jump_anim
        end
        if self.facing == :right
          self.image_sheet.tile_y += 10
        end
      end
    end
  end

  def draw camera
    super camera if self.damaged_duration <= 0 || self.damaged_duration >= @@red_duration || (self.damaged_duration / @@damaged_flash_duration).round % 2 == 0

    if self.speech != nil
      Text.draw_bubble @speech, self.pos_x + self.width / 2, self.pos_y, camera
    end
  end
end
