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
        Text.draw ["TROLOLOL", "It ain't"], 80, 80, 0xff000000
        Images[:logo].draw(0,0,0)
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
