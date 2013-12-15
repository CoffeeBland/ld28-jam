require "engine/state"

module LD28
  module States
    class Logo < State

      def transition_draw from, to, percent
        color = Gosu::Color.new 0, 0, 0, 0
      end

      def transition from, to, start, stop, current
        if @now_in_for >= start && @now_in_for <= stop
          length = stop - start
          current_rel = current - start
          transition_draw from, to, current_rel / length
        end
        set_color 0x000000FF
      end

      def update delta
        @now_in_for += delta
        if @now_in_for > 6000
          @game.switch_to :menu
        end
      end

      def draw
        transition 0x000000FF, 0xFFFFFFFF, 0, 1000, @now_in_for
        transition 0xFFFFFFFF, 0x000000FF, 5000, 6000, @now_in_for
        set_color 0xFFFFFFFF
        draw_rect 0, 0, @game.width, @game.height
        Images[:logo].draw_centered
        Text.draw ["TROLOLOL", "It ain't"], 80, 80, 0xff000000
      end

      def init
        super
        self.input_press Gosu::KbEscape, Proc.new {
          @game.switch_to :menu
        }
      end

      def enter
        super
        @now_in_for = 0
      end

    end
  end
end
