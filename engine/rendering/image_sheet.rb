require $engineDir + '/utils/aabb'

class ImageSheet < AABB
	# Rendering properties
	attr_accessor :tiles
	attr_accessor :z_index
	attr_accessor :color

	# Animation properties
	def frames_per_second
		@frames_per_second
	end
	def frames_per_second= val
		@frames_per_second = val
		self.frame_duration = 1000 / val
	end
	def frame_duration
		@frame_duration
	end
	def frame_duration= val
		@frame_duration = val
		self.frames_per_second = 1000 / val
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

	def initialize window, imagePath, tileWidth, tileHeight, options
		@tiles = Gosu::Image.load_tiles window, imagePath, tileWidth, tileHeight
		@tileX = 0
		@tileY = 0
		@pos_x = 0
		@pos_y = 0
		@width = tileWidth
		@height = tileHeight
		@color = 0xffffff00
		@z_index = 0

		if options[:frames_per_second] != nil
			self.frames_per_second = options[:frames_per_second]
			self.frameTime = self.frame_duration
		elsif options[:frame_duration] != nil
			self.frame_duration = options[:frame_duration]
			self.frameTime = self.frame_duration
		end
	end

	def update delta
		unless self.frame_duration.nil? or self.frame_duration <= 0
			self.frameTime -= delta
			while self.frameTime < 0
				self.frameTime += self.frame_duration
				self.tileX += 1
			end
		end
	end

	def draw camera
		self.tiles[self.tileX][self.tileY].draw self.pos_x - camera.pos_x, self.pos_y - camera.pos_y, self.z_index, 1, 1, self.color
	end
end
