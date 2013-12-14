require $engineDir + '/game/Collisionnable'

class Entity < Collisionnable
	attr_accessor :imageSheet
	attr_accessor :imageSheetOffsetX
	attr_accessor :imageSheetOffsetY
  def health
    @health
  end
  def health= value
    @health = value
    if (@health < 0)
      self.die
    end
  end

	def shouldBeRemoved
		@shouldBeRemoved
	end
	def remove
		@shouldBeRemoved = true
	end

	def initialize posX, posY, width, height, options = Hash.new
		super posX, posY, width, height, options
		self.imageSheet = options[:imageSheet].nil? ? nil : options[:imageSheet]
		self.imageSheetOffsetX = options[:imageSheetOffsetX].nil? ? nil : options[:imageSheetOffsetX]
		self.imageSheetOffsetY = options[:imageSheetOffsetY].nil? ? nil : options[:imageSheetOffsetY]
		self.health = options[:health].nil? ? 0 : options[:health]
		@shouldBeRemoved = false
	end

  def die
    self.remove
  end

	def drawable?
		self.imageSheet != nil && self.imageSheetOffsetX != nil && self.imageSheetOffsetY != nil
	end

	def update delta, world
		super delta, world

		if self.drawable?
			self.imageSheet.posX = self.posX + self.imageSheetOffsetX
			self.imageSheet.posY = self.posY + self.imageSheetOffsetY
			self.imageSheet.update delta
		end
	end

	def draw camera
		if self.drawable?
			self.imageSheet.draw camera
		end
	end
end
