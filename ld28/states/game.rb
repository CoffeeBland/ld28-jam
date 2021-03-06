require 'engine/state'
require 'engine/game/world'
require 'engine/game/entity'
require 'engine/rendering/images'
require 'pp'
require 'ld28/sfx/smoke'
require 'ld28/actions/punch'
require 'ld28/actions/interact'
require 'ld28/maps/courtyard'
require 'engine/utils/settings'

module LD28
  module States
    class Game < State

      attr_reader :camera
      attr_reader :game
      attr_reader :world
      attr_accessor :player

      def update delta
        if @new_map != nil
          @world.reset
          @current_map = @maps[@new_map]
          @current_map.enter self
          @new_map = nil
        end

        super delta

        @world.update delta
        @current_map.update self, @tick unless @current_map.nil?
        @tick += delta

        @camera.center_on @player
      end


      def draw
        super

        # Drawing the world & the map
        @world.draw @camera
        @current_map.draw self, @game unless @current_map.nil?

        # UI
        unless @player.nil?
          Images[:health_bar_container].draw 16, 16, Z[:ui_health_bar]
          draw_rect 16 + 15, 16 + 8, @player.health, 16, Z[:ui_health], 0xFFFF0000
        end

        # BEHOLD! Debugging down here
        if Engine::Utils::Settings[:debugging]
          set_color 0xEE00EEFF
          @world.entities.each do |e|
            draw_rect_outline(
              e.pos_x - @camera.pos_x,
              e.pos_y - @camera.pos_y,
              e.width, e.height, Z[:debugging]
              )
            if e.angle == :diagonal_tl_br
              draw_line(
                  e.left - @camera.pos_x,
                  e.top - @camera.pos_y,
                  e.right  - @camera.pos_x,
                  e.bottom - @camera.pos_y,
                  Z[:debugging]
                )
            elsif e.angle == :diagonal_tr_bl
              draw_line(
                  e.right - @camera.pos_x,
                  e.top - @camera.pos_y,
                  e.left  - @camera.pos_x,
                  e.bottom - @camera.pos_y,
                  Z[:debugging]
                )
            end
          end
          @current_time = Gosu::milliseconds
          @fps = ((@fps.nil? ? 60 : @fps) * 0.9) + (1000.0 / (@current_time - (@last_time.nil? ? 0 : @last_time)) * 0.1)
          Text.draw [@fps.round.to_s], 4, 4, 0, Z[:debugging], 0xFFFF00FF
          @last_time = Gosu::milliseconds
        end
      end

      def init
        super

        @world = World.new
        @camera = Camera.new 0, 0, @game.width, @game.height
        @camera.decal_y = -150
        @player = nil
        @maps = Hash.new

        # Initialize all teh inputs!
        self.input_down Gosu::KbLeft, Proc.new {
            @player.facing_y = :none
            @player.facing = :left if @player.current_action.nil?
            if @player.last_collision.in_collision_bottom
              @player.velocity_x -= 1.1
            else
              @player.velocity_x -= 0.1
            end
          }
        self.input_down Gosu::KbRight, Proc.new {
            @player.facing_y = :none
            @player.facing = :right if @player.current_action.nil?
            if @player.last_collision.in_collision_bottom
              @player.velocity_x += 1.1
            else
              @player.velocity_x += 0.1
            end
          }
        self.input_press Gosu::KbUp, Proc.new {
            @player.facing_y = :up
            if @player.last_collision.in_collision_bottom && @player.current_action.nil?
              @player.velocity_y -= 6
              @world.add Smoke.new(@player.pos_x + @player.width / 2, @player.pos_y + @player.height)
            end
            @world.check_for_door_with @player
          }
        self.input_press Gosu::KbZ, Proc.new {
            if @player.current_action.nil?
              @player.facing = :left
              @player.do LD28::Actions::Punch.new
            end
          }
        self.input_press Gosu::KbX, Proc.new {
            if @player.current_action.nil?
              @player.facing = :right
              @player.do LD28::Actions::Punch.new
            end
          }
        self.input_press Gosu::KbSpace, Proc.new {
            if @player.current_action.nil?
              @player.do LD28::Actions::Interact.new
            end
          }
      end

      def enter
        super

        @tick = 0
        @maps[:castle] = LD28::Maps::Castle.new
        @maps[:courtyard] = LD28::Maps::Courtyard.new
        set_current_map :castle
      end

      def leave
        super
      end

      def set_current_map map
        @new_map = map
      end

    end
  end
end
