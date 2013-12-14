require $engineDir + '/utils/AABB'

class ImageSheet < AABB
	# Rendering properties 
	attr_accessor :tiles
	attr_accessor :zIndex
	attr_accessor :color
	
	# Animation properties
	def framesPerSecond
		@framesPerSecond
	end
	def framesPerSecond= val
		@framesPerSecond = val
		self.frameDuration = 1000 / val
	end
	def frameDuration
		@frameDuration
	end
	def frameDuration= val
		@frameDuration = val
		self.framesPerSecond = 1000 / val
	end
	attr_accessor :frameTime
	
	# Tiling accessors
	def tileX
		@tileX
	end
	def tileX= val
		@tileX = val
		while @tileX < 0
			@tileX += self.tilesX
		end
		while @tileX >= self.tilesX
			@tileX -= self.tilesX
		end
	end
	
	def tileY
		@tileY
	end
	def tileY= val
		@tileY = val
		while @tileY < 0
			@tileY += self.tilesY
		end
		while @tileY >= self.tilesY
			@tileY -= self.tilesY
		end
	end
	
	# Utility accessors
	def tilesX
		self.tiles.length
	end
	def tilesY
		self.tiles[self.tileX]
	end
	
	def initialize window, imagePath, tileWidth, tileHeight 
		@tiles = Gosu::Image.load_tiles window, imagePath, tileWidth, tileHeight
		@tileX = 0
		@tileY = 0
		@posX = 0
		@posY = 0
		@width = tileWidth
		@height = tileHeight
		@color = 0xffffff00
		@zIndex = 0
	end
	
	def update delta
		unless self.frameDuration.nil? or self.frameDuration <= 0
			self.frameTime -= delta
			while self.frameTime < 0
				self.frameTime += self.frameDuration
				self.tileX += 1
			end
		end
	end
	
	def draw camera
		self.tiles[self.tileX][self.tileY].draw self.posX - camera.posX, self.posY - camera.posY, self.zIndex, 1, 1, self.color
	end
end