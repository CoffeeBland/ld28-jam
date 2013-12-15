require "engine/state"

module LD28
  module States
    class Menu < State

      def update delta
        super delta
      end

      def draw
        transition 0x000000FF, 0, 1000, @now_in_for
        set_color 0xFFFFFFFF
        draw_rect 0, 0, @game.width, @game.height
        Text.draw ["Le One Kingdom"], 50, 50, 0xff000000
        Text.draw ["Press the enter key to play"], 50, @game.height - 50, 0xff000000
      end

      def init
        super
        self.input_press Gosu::KbEscape, Proc.new {
          @game.close
        }
        self.input_press Gosu::KbEnter, Proc.new {

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
