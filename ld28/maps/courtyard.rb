require "engine/game/map"
require "engine/game/entity"
require "engine/game/actor"
require "engine/physics/collisionnable_block"

module LD28
  module Maps
    class Courtyard < Map
      def initialize
        @background = 0x309BD0FF
      end

      def update state, tick
        if (tick / 1500) % 3 == 0
          state.player.say ['I am the HOOONLY hero!']
          @joj.say ['fack']
        elsif (tick / 1500) % 3 == 1
          state.player.say ['Me saaave whorld!', 'Mhe noo sthupid!']
          @joj.say ['fock']
        else
          state.player.say nil
          @joj.say ['fick']
        end
      end

      def draw state, game
        super state, game
        # BG
        Images[:desert_bg].draw -768 - state.camera.pos_x, 130 - state.camera.pos_y, 0
        Images[:desert_bg].draw 0 - state.camera.pos_x, 130 - state.camera.pos_y, 0
        Images[:desert_bg].draw 768 - state.camera.pos_x, 130 - state.camera.pos_y, 0

        # Objects / Buildings
        Images[:castle].draw -150 - state.camera.pos_x, 150 - state.camera.pos_y, 1
        Images[:gate].draw -300 - state.camera.pos_x, 150 - state.camera.pos_y, 1
        Images[:gate].draw 300 - state.camera.pos_x, 150 - state.camera.pos_y, 1

        # Flooring
        state.set_color 0x423600FF
        state.draw_rect -5000 - state.camera.pos_x, 350 - state.camera.pos_y, 10008, 2000
        (0..416).each do |n|
          Images[:tile1].draw -5000 + (n * 24) - state.camera.pos_x, 350 - state.camera.pos_y, 1
        end
      end

      def enter state
        super state

        get_hero_sheet = lambda {
          ImageSheet.new File.join('res', 'images', 'homme.png'), 24, 48, :frames_per_second => 10
        }
        state.player = LD28::Characters::Hero.new 100, 120, 18, 32,
        { :image_sheet => get_hero_sheet.call,
          :health => 100,
          :image_sheet_offset_x => -3,
          :image_sheet_offset_y => -16}
        state.world.add state.player
        @joj = Actor.new 30, 130, 24, 48, :image_sheet => get_hero_sheet.call, :health => 100
        state.world.add @joj
        # Floor
        state.world.add CollisionnableBlock.new -5000, 350, 10008, 20
        # Gate Left
        state.world.add CollisionnableBlock.new -300, 160, 48, 200
        # Gate Right
        state.world.add CollisionnableBlock.new 300, 160, 48, 200
        # Castle Door
        state.world.add GhostDoor.new -40, 254, 80, 96, {
          :action => Proc.new { |sender, world|
            if sender.is_a?(LD28::Characters::Hero) && sender.facing_y == :up
              state.set_current_map :castle
            end
          }
        }
      end

      def leave state
        super state

      end

    end
  end
end
