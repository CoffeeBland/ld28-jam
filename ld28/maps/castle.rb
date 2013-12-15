require "engine/game/map"
require "engine/game/entity"
require "engine/game/character"
require "engine/game/collisionnable"
require "engine/game/collisionnable_block"

module LD28
  module Maps
    class Castle < Map
      def initialize
        @background = 0x000000FF
      end

      def update state, tick
        if (tick / 3000) % 2 == 1
          @king.say ['I am the ONLY King!']
        else
          @king.say nil
        end
      end

      def draw state, game
        super state, game

        # Wall
        state.set_color 0x444444FF
        state.draw_rect -324 - state.camera.pos_x, 126 - state.camera.pos_y, 648, 272
        state.set_color 0xE1E1E1FF
        state.draw_rect -300 - state.camera.pos_x, 150 - state.camera.pos_y, 600, 200
        # Door
        state.set_color 0x999999FF
        state.draw_rect 300 - state.camera.pos_x, 254 - state.camera.pos_y, 12, 96
        (0..24).each do |n|
          Images[:tile2].draw -300 + (n * 24) - state.camera.pos_x, 350 - state.camera.pos_y, 1
        end
        # Throne
        (0..5).each do |n|
          Images[:tile2].draw -300 + (n * 24) - state.camera.pos_x, 326 - state.camera.pos_y, 1
        end
        Images[:tile2].draw -276 - state.camera.pos_x, 302 - state.camera.pos_y, 1

        Text.draw ["The Only Throne Room"], -288 - state.camera.pos_x, 160 - state.camera.pos_y, 0xff000000
      end

      def enter state
        super state

        get_hero_sheet = lambda { |img_name|
          ImageSheet.new File.join('res', 'images', img_name + '.png'), 24, 48, :frames_per_second => 10
        }

        @hero_init_pos_x = @hero_init_pos_x.nil? ? (-300 + 8*24) : (300-48)
        @hero_init_pos_y = (350 - (3*24))

        state.player = LD28::Characters::Hero.new @hero_init_pos_x, @hero_init_pos_y, 18, 36, {
            :image_sheet => get_hero_sheet.call('hero'),
            :health => 100,
            :image_sheet_offset_x => -3,
            :image_sheet_offset_y => -12
          }
        state.world.add state.player
        @king = Character.new (-299 + 1*24), (350 - 5*24), 18, 32, {
            :image_sheet => get_hero_sheet.call('homme'),
            :health => 100,
            :image_sheet_offset_x => -3,
            :image_sheet_offset_y => -16
          }
        @king.facing = :right
        state.world.add @king

        # Throne
        state.world.add CollisionnableBlock.new -276, 302, 24, 24
        state.world.add CollisionnableBlock.new -282, 270, 6, 56
        # Throne pedestal
        state.world.add CollisionnableBlock.new -300, 326, 144, 6
        state.world.add CollisionnableBlock.new -300, 332, 150, 6
        state.world.add CollisionnableBlock.new -300, 338, 156, 6
        state.world.add CollisionnableBlock.new -300, 344, 162, 6
        # Floor
        state.world.add CollisionnableBlock.new -300, 350, 600, 48
        # Left wall
        state.world.add CollisionnableBlock.new -324, 150, 24, 200
        # Right wall
        state.world.add CollisionnableBlock.new 300, 150, 24, 200
        # Door
        state.world.add PhysicalDoor.new 299, 254, 12, 96, {
          :action => Proc.new { |sender, col, world|
            state.set_current_map :courtyard
          }
        }
      end

      def leave state
        super state
      end

    end
  end
end
