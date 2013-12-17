require "engine/game/entity"
require "engine/rendering/text"

module Engine
  module Game
    class Character < Entity
      @@default_still_anim = 0
      @@default_speech_anim = 1
      @@default_walk_anim = 2
      @@default_jump_anim = 5
      @@damaged_duration = 500
      @@red_duration = 400
      @@speech_bubble_distance = 20

      attr_reader :current_action
      attr_accessor :update_anim
      attr_accessor :facing
      attr_accessor :facing_y
      attr_accessor :landed
      attr_accessor :damaged_duration

      def initialize pos_x, pos_y, width, height, options = Hash.new
        super pos_x, pos_y, width, height, options
        self.update_anim = options[:update_anim] unless options[:update_anim].nil?
        self.facing = :left
        self.landed = false
        self.damaged_duration = 0
        @attributes = Hash.new
        @speech_stack = Array.new

        self[:name] = options[:name].nil? ? "Sir Unnamed" : options[:name]
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
        self.say ["Ouch!"], 500
      end

      def say speech, duration = 1000
        @speech_stack.push [speech, duration]
      end
      def speech
        if @speech_stack.length > 0
          @speech_stack[-1][0]
        else
          nil
        end
      end

      def do action
        @current_action = action
      end

      def update delta, world
        self.landed = false

        #decay damaged duration
        if self.damaged_duration > 0
          self.damaged_duration -= delta
          self.image_sheet.color = 0xffffffff if self.damaged_duration <= @@red_duration
        end

        #determine action
        if self.current_action != nil
          self.current_action.update delta, world, self
          @current_action = nil if self.current_action.completed?
        end

        #determine if landing
        touched_ground = self.last_collision.in_collision_bottom
        super delta, world
        if !touched_ground && self.last_collision.in_collision_bottom
          self.landed = true
        end

        #update speech
        self.update_speech delta if @speech_stack.length > 0

        #update anim
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

      def update_speech delta
        @speech_stack[-1][1] -= delta
        tmp = @speech_stack[-1][1]
        if tmp < 0
          @speech_stack.pop
          self.update_speech -tmp if @speech_stack.length > 0
        end
      end

      def draw camera
        super camera if self.damaged_duration <= 0 || self.damaged_duration >= @@red_duration || @flickr
        @flickr = !@flickr

        Text.draw_name self, camera, self.z_index_decal
        if self.speech != nil
          Text.draw_bubble self.speech, self.pos_x + self.width / 2, self.pos_y - @@speech_bubble_distance, camera, self.z_index_decal
        end
      end
    end
  end
end
