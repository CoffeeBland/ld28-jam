require "engine/game/map"
require "engine/game/entity"
require "engine/game/character"

module LD28
  module Maps
    class Castle < Map
      def initialize
        @@background = 0x000000FF
      end

      def update state, tick
        #state.player.say nil
      end

      def draw state, game
        super state, game

        # Objects / Buildings
        #Images[:castle].draw -300 - state.camera.pos_x, 150 - state.camera.pos_y, 2

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

        get_hero_sheet = lambda {
          ImageSheet.new File.join('res', 'images', 'homme.png'), 24, 48, :frames_per_second => 10
        }
        state.player = Hero.new 220, 160, 18, 32,
        { :image_sheet => get_hero_sheet.call,
          :health => 100,
          :image_sheet_offset_x => -3,
          :image_sheet_offset_y => -16}
        state.world.add state.player
        state.world.add Character.new 30, 130, 24, 48, :image_sheet => get_hero_sheet.call, :health => 100

        # Throne
        state.world.add Entity.new -276, 302, 24, 24, {:gravitates => false, :collides => false}
        state.world.add Entity.new -282, 270, 6, 56, {:gravitates => false, :collides => false} # dossier
        # Throne pedestal
        state.world.add Entity.new -300, 326, 144, 6, {:gravitates => false, :collides => false}
        state.world.add Entity.new -300, 332, 150, 6, {:gravitates => false, :collides => false}
        state.world.add Entity.new -300, 338, 156, 6, {:gravitates => false, :collides => false}
        state.world.add Entity.new -300, 344, 162, 6, {:gravitates => false, :collides => false}
        # Floor
        state.world.add Entity.new -300, 350, 600, 48, {:gravitates => false, :collides => false}
        # Left wall
        state.world.add Entity.new -324, 150, 24, 200, {:gravitates => false, :collides => false}
        # Right wall
        state.world.add Entity.new 300, 150, 24, 200, {:gravitates => false, :collides => false}
        # Door
        # TODO: Add door entity with speciar collide
      end

      def leave state
        super state

      end

    end
  end
end
