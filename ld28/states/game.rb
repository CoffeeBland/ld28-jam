require "engine/state"
require "engine/game/world"
require "engine/game/entity"
require "engine/utils/images"

module LD28
  module States
    class Game < State
      attr_reader :camera
      attr_reader :game
      attr_reader :world
      attr_accessor :player

      def update delta
        super delta
        @world.update delta
        @camera.center_on @player

        @current_map.update self, @now_in_for unless @current_map.nil?
      end

      def draw
        transition 0x000000FF, 0, 1000, @now_in_for

        @world.draw @camera
        @current_map.draw self, @game unless @current_map.nil?

        # BEHOLD! Debugging down here
        set_color 0xEE00EEFF; @world.entities.each do |e| draw_rect_outline e.pos_x - @camera.pos_x, e.pos_y - @camera.pos_y, e.width, e.height, 1000; end
      end

      def init
        super
        @world = nil
        @camera = nil
        @player = nil
        @maps = Hash.new

        self.input_down Gosu::KbLeft, Proc.new {
          if @player.last_collision.in_collision_bottom
            @player.image_sheet.tile_y = 2
            @player.velocity_x -= 2
          else
            @player.image_sheet.tile_y = 3
            @player.velocity_x -= 0.1
          end
        }
        self.input_down Gosu::KbRight, Proc.new {
          if @player.last_collision.in_collision_bottom
            @player.image_sheet.tile_y = 6
            @player.velocity_x += 2
          else
            @player.image_sheet.tile_y = 7
            @player.velocity_x += 0.1
          end
        }
        self.input_down Gosu::KbUp, Proc.new {
          if @player.last_collision.in_collision_bottom
            @player.velocity_y -= 6
          end
        }
      end

      def enter
        super
        @world = World.new

        @maps[:castle] = LD28::Maps::Castle.new
        set_current_map :castle

        @camera = Camera.new 0, 0, @game.width, @game.height
        @camera.decal_y = -150
      end

      def leave
      end

      def set_current_map map
        @world.reset
        @current_map = @maps[map]
        @current_map.enter self
      end

    end
  end
end
