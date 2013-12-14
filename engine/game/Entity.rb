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

	def should_be_removed
		@should_be_removed
	end
	def remove
		@should_be_removed = true
	end

	def initialize pos_x, pos_y, width, height, options = Hash.new
		super pos_x, pos_y, width, height, options
		self.imageSheet = options[:imageSheet].nil? ? nil : options[:imageSheet]
		self.imageSheetOffsetX = options[:imageSheetOffsetX].nil? ? nil : options[:imageSheetOffsetX]
		self.imageSheetOffsetY = options[:imageSheetOffsetY].nil? ? nil : options[:imageSheetOffsetY]
		self.health = options[:health].nil? ? 0 : options[:health]
		@should_be_removed = false
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
			self.imageSheet.pos_x = self.pos_x + self.imageSheetOffsetX
			self.imageSheet.pos_y = self.pos_y + self.imageSheetOffsetY
			self.imageSheet.update delta
		end
	end

	def draw camera
		if self.drawable?
			self.imageSheet.draw camera
		end
	end
end
