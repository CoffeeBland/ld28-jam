class AABB
	attr_accessor :posX
	attr_accessor :posY
	attr_accessor :width
	attr_accessor :height
	
	def initialize posX, posY, width, height
		self.posX = posX
		self.posY = posY
		self.width = width
		self.height = height
	end
end