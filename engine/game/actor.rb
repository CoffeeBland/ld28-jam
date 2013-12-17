require "engine/game/character"

module Engine
  module Game
    class Actor < Character
      @@still_anim = 0
      @@speech_anim = 1
      @@walk_anim = 2
      @@scared_walk_anim = 3
      @@jump_anim = 5
      @@ouch_duration = 500

      attr_accessor :weapon
      def weapon= val
        @weapon = val
        unless val.image_sheet.nil?
          @weapon_decal_x = (self.width - val.image_sheet.width) / 2
          @weapon_decal_y = self.height - val.image_sheet.height
        end
      end
      def weapon
        @weapon
      end

      def display_weapon_behind?
        @display_weapon_behind
      end
      def display_weapon_behind= val
        @display_weapon_behind = val
      end

      def hit_for damage, world, duration = @@damaged_duration
        super damage, world, duration
        self.say ["Ouch!"], @@ouch_duration
      end

      def update_anim world
        if self.current_action == nil
          self.image_sheet.tile_y = self.speech.nil? ?  @@still_anim :  @@speech_anim
          if self.last_collision.in_collision_bottom
            if !self.velocity_x.between?(
                -Collisionnable::DISTANCE_TOLERANCE,
                Collisionnable::DISTANCE_TOLERANCE
                )
              self.image_sheet.tile_y = @@walk_anim
            end
            if self.landed
              world.add Smoke.new(self.pos_x + self.width / 2, self.pos_y + self.height)
            end
          else
            self.image_sheet.tile_y = @@jump_anim
          end
          if self.facing == :right
            #self.image_sheet.tile_y += 10
          end
        end
      end

      def update delta, world
        super delta, world
        unless self.weapon.nil? || self.weapon.image_sheet.nil?
          self.weapon.image_sheet.pos_x = self.pos_x + @weapon_decal_x
          self.weapon.image_sheet.pos_y = self.pos_y + @weapon_decal_y
        end
      end

      def draw camera
        if self.weapon.nil? || self.weapon.image_sheet.nil?
          super camera
        else
          self.weapon.image_sheet.tile_x = self.image_sheet.tile_x
          self.weapon.image_sheet.tile_y = self.image_sheet.tile_y
          self.weapon.image_sheet.reverse = self.image_sheet.reverse
          if self.display_weapon_behind?
            self.weapon.image_sheet.draw camera, self.z_index_decal
            super camera
          else
            super camera
            self.weapon.image_sheet.draw camera, self.z_index_decal
          end
        end
      end
    end
  end
end
