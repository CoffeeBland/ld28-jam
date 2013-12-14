require "engine/state"

module LD28
  module States
    class Menu < State

      def update delta
      end

      def draw
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
