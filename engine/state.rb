module Engine
  module Game
    class State
      def initialize game
        @press = Hash.new
        @release = Hash.new
        @down = Hash.new
        @game = game
      end

      def update delta
        if delta > 1000; return; end
        @now_in_for += delta
      end

      def draw
        raise "Implement draw in game state #{self.class.name}"
      end

      def init
        @has_been_initialized = true
      end

      def enter
        unless @has_been_initialized
          self.init
        end
        @now_in_for = 0
      end

      def leave
      end

      def press id
        unless @press[id].nil?
          @press[id].call
        end
      end
      def input_press id, function
        @press[id] = function
      end

      def release id
        unless @release[id].nil?
          @release[id].call
        end
      end
      def input_release id, function
        @release[id] = function
      end

      def down id
        unless @down[id].nil?
          @down[id].call
        end
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

      # Transitions
      def transition_draw color, percent
        color = Gosu::Color.rgba color
        color.alpha = (color.alpha == 0) ? percent * 255 : (1.to_f-percent) * 255

        # Ready to draw
        set_color color
        draw_rect 0, 0, @game.width, @game.height, 100
        set_color 0x000000FF
      end

      def transition color, start, stop, current
        if current >= start && current <= stop
          length = stop - start
          current_rel = current - start
          transition_draw color, current_rel.to_f / length.to_f
        end
      end
    end
  end
end
