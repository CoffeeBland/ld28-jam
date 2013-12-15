require "engine/state"
require "engine/game/world"
require "engine/game/entity"
require "engine/utils/images"
require "pp"
require "ld28/sfx/smoke"
require "ld28/actions/punch"
require "ld28/maps/courtyard"

module LD28
  module States
    class Game < State
      attr_reader :camera
      attr_reader :game
      attr_reader :world
      attr_accessor :player

      def update delta
        if @new_map != nil
          @world.reset
          @current_map = @maps[@new_map]
          @current_map.enter self
          @new_map = nil
        end

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
          multiplier = 1
          if @player.current_action.nil?
            @player.facing = :left
          else
            multiplier *= 0.25
          end
          if @player.last_collision.in_collision_bottom
            @player.velocity_x -= 1 * multiplier
          else
            @player.velocity_x -= 0.1 * multiplier
          end
        }
        self.input_down Gosu::KbRight, Proc.new {
          multiplier = 1
          if @player.current_action.nil?
            @player.facing = :right
          else
            multiplier *= 0.25
          end
          if @player.last_collision.in_collision_bottom
            @player.velocity_x += 1 * multiplier
          else
            @player.velocity_x += 0.1 * multiplier
          end
        }
        self.input_press Gosu::KbUp, Proc.new {
          if @player.last_collision.in_collision_bottom && @player.current_action.nil?
            @player.velocity_y -= 5
            @world.add Smoke.new(@player.pos_x + @player.width / 2, @player.pos_y + @player.height)
          end
        }
        self.input_press Gosu::KbZ, Proc.new {
          if @player.current_action.nil?
            @player.facing = :left
            @player.do Punch.new
          end
        }
        self.input_press Gosu::KbX, Proc.new {
          if @player.current_action.nil?
            @player.facing = :right
            @player.do Punch.new
          end
        }
      end

      def enter
        super
        @world = World.new

        @maps[:castle] = LD28::Maps::Castle.new
        @maps[:courtyard] = LD28::Maps::Courtyard.new
        set_current_map :castle

        @camera = Camera.new 0, 0, @game.width, @game.height
        @camera.decal_y = -150
      end

      def leave
      end

      def set_current_map map
        @new_map = map
      end

    end
  end
end
