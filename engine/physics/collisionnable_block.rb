require "engine/game/entity"
include Engine::Game

module Engine
  module Physics
    class CollisionnableBlock < Entity
      BLOCK_OPTIONS = {:gravitates => false, :collides => false, :rebound_factor_y => 0}

      def initialize pos_x, pos_y, width, height, options = Hash.new
        super pos_x, pos_y, width, height, BLOCK_OPTIONS.merge(options)
      end

    end
    class BlockAngleTL_BR < Entity
      TL_BR_OPTIONS = {
          :gravitates => false,
          :collides => false,
          :rebound_factor_y => 0,
          :angle=> :diagonal_tl_br
        }

      def initialize pos_x, pos_y, width, height, options = Hash.new
        super pos_x, pos_y, width, height, TL_BR_OPTIONS.merge(options)
      end
    end
    class BlockAngleTR_BL < Entity
      TR_BL_OPTIONS = {
          :gravitates => false,
          :collides => false,
          :rebound_factor_y => 0,
          :angle=> :diagonal_tr_bl
        }

      def initialize pos_x, pos_y, width, height, options = Hash.new
        super pos_x, pos_y, width, height, TR_BL_OPTIONS.merge(options)
      end
    end
  end
end
