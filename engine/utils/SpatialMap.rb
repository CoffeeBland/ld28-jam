class SpatialMap
	def initialize tile_size
		@tile_size = tile_size
		@map = Hash.new
		@objects = Hash.new
	end

	def put object
		rangeX = object.posX.floor..(object.posX + object.width)
		rangeY = object.posY.floor..(object.posY + object.height)
		@objects[object] = [rangeX, rangeY]

		rangeX.step @tile_size do |x|
			rangeY.step @tile_size do |y|
				elements = @map[[x, y]]
				if elements == nil
					elements = Array.new
					@map[[x, y]] = elements
				end
				elements.push object
			end
		end
	end

	def remove object
		tiles = @objects.delete object
		tiles[0].step @tile_size do |x|
			tiles[1].step @tile_size do |y|
				objects = @map[[x, y]]
				objects.delete object
				if objects.length == 0
					@map[[x, y]].delete objects
				end
			end
		end
	end

	def update object
		self.remove object
		self.put object
	end

	def get region
		objects = Set.new
		rangeX = region.posX.floor..(region.posX + region.width)
		rangeY = region.posY.floor..(region.posY + region.height)
		rangeX.step @tile_size  do |x|
			rangeY.step @tile_size  do |y|
				objects.concat @map[[x, y]]
			end
		end
		objects
	end
end
