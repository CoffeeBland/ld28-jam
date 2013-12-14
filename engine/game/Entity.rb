require $engineDir + '/game/Collisionnable'

class Entity < Collisionnable
	attr_accessor :imageSheet
	attr_accessor :imageSheetOffsetX
	attr_accessor :imageSheetOffsetY

	def shouldBeRemoved
		@shouldBeRemoved
	end
	def remove
		@shouldBeRemoved = true
	end
	
	def initialize posX, posY, width, height, options = Hash.new, imageSheet = nil, imageSheetOffsetX = nil, imageSheetOffsetY = nil
		super posX, posY, width, height, options
		self.imageSheet = imageSheet
		self.imageSheetOffsetX = imageSheetOffsetX
		self.imageSheetOffsetY = imageSheetOffsetY
		@shouldBeRemoved = false
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