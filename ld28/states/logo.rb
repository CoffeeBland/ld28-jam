require "gosu"
require "engine/state"

module LD28
  module States
    class Logo < State

      def update delta
        super delta
        if @now_in_for > @exit_at
          @game.switch_to :menu
        end
      end

      def draw
        transition 0x000000FF, 0, 1000, @now_in_for
        transition 0x00000000, @exit_at-1000, @exit_at, @now_in_for
        set_color 0xFFFFFFFF
        draw_rect 0, 0, @game.width, @game.height
        Images[:logo].draw_centered
      end

      def init
        super
        self.input_press Gosu::KbEscape, Proc.new {
          @exit_at = @now_in_for + 1000
        }
      end

      def enter
        super
        @exit_at = 6000
      end

    end
  end
end
