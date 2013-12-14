require $engineDir + '/utils/SpatialMap'

class World
	attr_accessor :gravityX
	attr_accessor :gravityY
	attr_accessor :airFriction
	attr_reader :spatialMap
	attr_reader :entities

	def initialize
		@spatialMap = SpatialMap.new
		@entities = Array.new
		self.gravityX = 0
		self.gravityY = 1
		self.airFriction = 0.995
	end

	def update delta
		toRemove = Array.new
		self.entites.each do |entity|
			if entity.shouldBeRemoved
				toRemove.add entity
			else
				entity.update delta, self
				if entity.collisions && entity.hasMoved
					self.spatialMap.update entity
				end
			end
		end
		toRemove.each do |entity|
			self.remove entity
		end
	end

	def draw camera
		self.spatialMap.get(camera).each do |entity|
			entity.draw camera
		end
	end

	def add entity
		self.entities.add entity
		self.spatialMap.put entity
	end
	def remove entity
		self.entities.delete entity
		self.spatialMap.remove entity
	end
end
