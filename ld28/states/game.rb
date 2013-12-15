require "engine/state"
require "engine/game/world"

module LD28
  module States
    class Game < State
      @world = nil
      @camera = nil

      def update delta
        super delta
        @world.update delta
      end

      def draw
        transition 0x000000FF, 0, 1000, @now_in_for
        set_color 0xFF00FF99
        draw_rect 0, 0, @game.width, @game.height
        @world.draw @camera
      end

      def init
        super
      end

      def enter
        super
        @world = World.new
        @camera = Camera.new 0, 0, @game.width, @game.height
      end

      def leave
      end

    end
  end
end
