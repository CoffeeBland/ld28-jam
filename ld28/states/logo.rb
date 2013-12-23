require "gosu"
require "engine/state"

module LD28
  module States
    class Logo < State

      def update delta
        super delta

        unless @time_before_exit.nil?
          if @time_before_exit > 0
            @time_before_exit -= delta
          else
            @time_before_exit = nil
            @game.switch_to :menu, 0x00000000, 1000
          end
        end
      end

      def draw
        super

        set_color 0xFFFFFFFF
        draw_rect 0, 0, @game.width, @game.height
        Images[:logo].draw_centered
      end

      def init
        super

        self.input_press Gosu::KbEscape, Proc.new {
            @time_before_exit = nil
            @game.switch_to :menu, 0x00000000, 1000
          }
      end

      def enter
        super

        @time_before_exit = 3000
      end
    end
  end
end
