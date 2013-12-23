require 'engine/utils/z'

module Engine
  module Game
    class State
      def initialize game
        @press = Hash.new
        @release = Hash.new
        @down = Hash.new
        @game = game
      end

      # Transition management
      def fade_in(color, duration)
        init_color = Gosu::Color.new color
        init_color.alpha = 255
        final_color = Gosu::Color.new color
        final_color.alpha = 0

        self.fade_to init_color, final_color, duration
      end
      def fade_out(color, duration)
        init_color = Gosu::Color.new color
        init_color.alpha = 0
        final_color = Gosu::Color.new color
        final_color.alpha = 255

        self.fade_to init_color, final_color, duration
      end
      def fade_to(init_color, final_color, duration)
        @transition_left = duration.to_f
        @transition_duration = duration.to_f
        @transition_initial_color = init_color
        @transition_current_color = init_color.dup if @transition_current_color.nil?
        @transition_final_color = final_color
      end
      def in_transition?
        @transition_left > 0
      end
      def transition_left
        @transition_left = 0 if @transition_left.nil?
        @transition_left
      end

      # State routines
      def update delta
        if self.in_transition?
          @transition_left -= delta
        end
      end

      def draw
        # Transition
        if self.in_transition?
          progress_ratio = @transition_left / @transition_duration
          @transition_current_color.alpha =
            (@transition_initial_color.alpha * progress_ratio) +
            (@transition_final_color.alpha * (1 - progress_ratio))
          self.draw_rect 0, 0, @game.width, @game.height, Z[:fade_in_out], @transition_current_color
        end
      end

      # State management
      def init
        @has_been_initialized = true
      end

      def enter
        unless @has_been_initialized
          self.init
        end
      end

      def leave
      end

      # Input management
      def press id
        unless @press[id].nil?# || self.in_transition?
          @press[id].call
        end
      end

      def release id
        unless @release[id].nil?# || self.in_transition?
          @release[id].call
        end
      end

      def down id
        unless @down[id].nil?# || self.in_transition?
          @down[id].call
        end
      end
      # Input hook-ups
      def input_press id, function
        @press[id] = function
      end

      def input_release id, function
        @release[id] = function
      end

      def input_down id, function
        @down[id] = function
      end

      # Method redirect to game
      def set_color color
        @game.set_color color
      end

      def draw_rect x, y, width, height, z = 0, color = @game.color
        @game.draw_rect x, y, width, height, z, color
      end

      def draw_rect_outline x, y, width, height, z = 0
        @game.draw_rect_outline x, y, width, height, z
      end

      def draw_line x1, y1, x2, y2, z = 0, color = @game.color
        @game.draw_line(x1, y1, color, x2, y2, color, z)
      end
    end
  end
end
