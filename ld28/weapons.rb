require 'engine/game/weapon'

module LD28
  class Fist < Weapon
    def initialize
      super nil, 3, 1
    end
  end
  class IronSword < Weapon
    def initialize
      super ImageSheet.new(File.join('res', 'images', 'iron_sword.png'), 48, 48), 14, 20
    end
  end
end
