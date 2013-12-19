module Engine
  module Game
    class Cue
      attr_reader :cue
      attr_reader :act

      def act world, source
         @action.call world, source
      end

      def initialize cue, act
         @cue = cue
         @action = act
      end
    end

    class Action
      attr_reader :cues
      attr_reader :current_cue
      attr_reader :time_left

      def initialize duration, cues
        @duration = duration
        @time_left = duration
        @cues = cues
      end

      def next_cue
        if self.cues[-1] != nil && self.cues[-1].cue >= (self.time_left.to_f / @duration)
          @current_cue = self.cues.pop
        else
          nil
        end
      end

      def completed?
        self.time_left < 0
      end

      def update delta, world, source
        @time_left -= delta

        while self.next_cue != nil
          self.current_cue.act world, source
        end
      end
    end
  end
end
