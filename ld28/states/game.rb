require "engine/state"
require "engine/game/world"
require "engine/game/entity"
require "engine/utils/images"

module LD28
  module States
    class Game < State
      @world = nil
      @camera = nil

      def update delta
        super delta
        @world.update delta
        @camera.center_on @player
      end

      def draw
        transition 0x000000FF, 0, 1000, @now_in_for
        set_color 0x309BD0FF
        draw_rect 0, 0, @game.width, @game.height
        Images[:desert_bg].draw 0 - @camera.pos_x, 60 - @camera.pos_y, 0
        Images[:desert_bg].draw 512 - @camera.pos_x, 60 - @camera.pos_y, 0

        @world.draw @camera
      end

      def init
        super

        self.input_down Gosu::KbLeft, Proc.new {
          @player.velocity_x -= 1
        }
      end

      def enter
        super
        @world = World.new

        hero_img_sheet = ImageSheet.new File.join('res', 'images', 'homme.png'), 24, 48, :frames_per_second => 5
        omg_sheet = ImageSheet.new File.join('res', 'images', 'homme.png'), 24, 48, :frames_per_second => 5
        @player = Hero.new 100, 120, 24, 48, :image_sheet => hero_img_sheet, :health => 100
        @world.add @player
        @world.add Character.new 30, 130, 24, 48, :image_sheet => omg_sheet, :health => 100
        @world.add Entity.new 0, 300, 600, 20, {:gravitates => false, :collides => false}

        @camera = Camera.new 0, 0, @game.width, @game.height
      end

      def leave
      end

    end
  end
end
