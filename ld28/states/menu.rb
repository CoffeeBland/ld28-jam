require "engine/state"
require "engine/rendering/camera"

module LD28
  module States
    class Menu < State

      def update delta
        super delta
      end

      def draw
        super

        set_color 0xffffffff
        draw_rect 0, 0, @game.width, @game.height
        Text.draw ["Le One Kingdom"], 50, 50, 0xff000000
        Text.draw ["Press the enter key to play"], 50, @game.height - 50, 0xff000000
      end

      def init
        super

        self.input_press Gosu::KbEscape, Proc.new {
            @game.close
          }
        self.input_press Gosu::KbReturn, Proc.new {
            @game.switch_to :game, 0x00000000, 1000
          }
      end

      def enter
        super
      end

      def leave
      end

    end
  end
end
