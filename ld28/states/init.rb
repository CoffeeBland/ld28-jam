require ED + '/states/State'

module LD28
  module States
    class Init < State

      def update delta
      end

      def draw
      end

      def init
        super
        self.input_press Gosu::KbEscape, Proc.new {
          puts 'Escape!'
        }
        self.input_down Gosu::KbLeft, Proc.new {
          puts 'Left!'
        }
      end

    end
  end
end
