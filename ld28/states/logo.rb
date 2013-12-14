require "engine/state"

module LD28
  module States
    class Logo < State

      def update delta
        @now_in_for += delta
        if @now_in_for > 3000
          #@game.switch_to :menu
        end
      end

      def draw
        self.set_color 0xFFFFFFFF
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
