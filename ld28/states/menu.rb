require "engine/state"

module LD28
  module States
    class Menu < State

      def update delta
        super delta
      end

      def draw
        transition 0x000000FF, 0, 1000, @now_in_for
      end

      def init
        super
        self.input_press Gosu::KbEscape, Proc.new {
          @game.close
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
