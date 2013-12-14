class SpatialMap
	def initialize tile_size
		@tile_size = tile_size
		@map = Hash.new
		@objects = Hash.new
	end

	def put object
		range_x = object.pos_x.floor..(object.pos_x + object.width)
		range_y = object.pos_y.floor..(object.pos_y + object.height)
		@objects[object] = [range_x, range_y]

		range_x.step @tile_size do |x|
			range_y.step @tile_size do |y|
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
		range_x = region.pos_x.floor..(region.pos_x + region.width)
		range_y = region.pos_y.floor..(region.pos_y + region.height)
		range_x.step @tile_size  do |x|
			range_y.step @tile_size  do |y|
				objects.concat @map[[x, y]]
			end
		end
		objects
	end
end
