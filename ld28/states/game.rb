require "engine/state"
require "engine/game/world"
require "engine/utils/images"

module LD28
  module States
    class Game < State
      @world = nil
      @camera = nil

      def update delta
        super delta
        @world.update delta
        #@player.update delta, @world
      end

      def draw
        transition 0x000000FF, 0, 1000, @now_in_for
        set_color 0x309BD0FF
        draw_rect 0, 0, @game.width, @game.height
        Images[:desert_bg].draw 0, 60, 0
        Images[:desert_bg].draw 512, 60, 0
        #@world.draw @camera
        #@player.draw @camera

      end

      def init
        super
        hero_img_sheet = ImageSheet.new File.join('res', 'images', 'homme.png'), 24, 48, :frames_per_second => 5
        #@player = Hero.new 100, 120, 24, 48, :image_sheet => hero_img_sheet, :health => 100, :world => @world
        #@world.add @player
      end

      def enter
        @world = World.new
        super
        @camera = Camera.new 0, 0, @game.width, @game.height
        #@camera.center_on @player
      end

      def leave
      end

    end
  end
end
