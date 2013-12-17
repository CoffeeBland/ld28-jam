module Engine
  module Game
    class Weapon
      attr_accessor :image_sheet
      attr_accessor :length
      attr_accessor :damage

      def initialize image_sheet, length, damage
        self.image_sheet = image_sheet
        self.length = length
        self.damage = damage
      end
    end
  end
end
