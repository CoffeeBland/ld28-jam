
require $engineDir + '/utils/AABB'

class Collision
	attr_accessor :collisionX
	attr_accessor :collisionY

	attr_accessor :distanceX
	attr_accessor :distanceY

	attr_accessor :inCollisionTop
	attr_accessor :inCollisionLeft
	attr_accessor :inCollisionRight
	attr_accessor :inCollisionBottom

	def initialize distanceX, distanceY
		self.distanceX = distanceX
		self.distanceY = distanceY
		self.inCollisionTop = false
		self.inCollisionBottom = false
		self.inCollisionLeft = false
		self.inCollisionRight = false
	end
end

class Collisionnable < AABB
	DISTANCE_TOLERANCE = 0.001
	STEP_MAXIMUM = 8

	attr_accessor :isFrictionnal
	attr_accessor :gravitates
	attr_accessor :collides
	attr_accessor :canBeCollided

	attr_accessor :frictionFactor
	attr_accessor :reboundFactor

	attr_accessor :angle

	attr_accessor :velocityX
	attr_accessor :velocityY
	attr_accessor :hasMoved

	attr_accessor :lastCollision

	def initialize posX, posY, width, height, options = Hash.new
		super posX, posY, width, height
		self.isFrictionnal = options[:isFrictionnal].nil? ? true : options[:isFrictionnal]
		self.gravitates = options[:gravitates].nil? ? true : options[:gravitates]
		self.collides = options[:collides].nil? ? true : options[:collides]
		self.canBeCollided = options[:canBeCollided].nil? ? true : options[:canBeCollided]

		self.frictionFactor = options[:frictionFactor].nil? ? 0 : options[:frictionFactor]
		self.reboundFactor = options[:reboundFactor].nil? ? 0 : options[:reboundFactor]

		self.angle = options[:angle].nil? ? :none : options[:angle]

		self.velocityX = 0
		self.velocityY = 0
		self.hasMoved = false
	end

	def aabb
		AABB.new self.posX + [self.velocityX, 0].min,
			self.posY + [self.velocityY, 0].min,
			self.width + self.velocityX.abs,
			self.height + self.velocityY.abs
	end
	def inCollision? world, posX, posY
		set = world.spatialMap.get aabb.new posX, posY, self.width, self.height
		set.delete self
		set.each do |entity|
			if entity.canBeCollided
				case entity.angle
				when :none
					return true
				when :diagonal_tl_br
					cornerX = self.posX - entity.posX
					cornerY = self.posY + self.height - entity.posY
					if  cornerX < 0 ||
							cornerY > entity.height ||
							cornerX < entity.width &&
							cornerY > 0 &&
							entity.height / entity.width * cornerX - cornerY < 0
						return true
					end
				when :diagonal_tr_bl
					cornerX = self.posX + self.width - entity.posX
					cornerY = self.posY + self.height - entity.posY
					if  cornerX > entity.width ||
							cornerY > entity.height ||
							cornerX > 0 &&
							cornerY > 0 &&
							-entity.height / entity.width * cornerX + entity.height - cornerY < 0
						return true
					end
				end
			end
		end
		false
	end
	def inCollision? entity, positionX, positionY
		entity.canBeCollided &&
		xAligned?(entity, positionX, positionY) &&
		yAligned?(entity, positionX, positionY)
	end
	def xAligned? entity, positionX, positionY
		positionX - entity.posX + entity.width < DISTANCE_TOLERANCE &&
		positionX + self.width - entity.posX > -DISTANCE_TOLERANCE
	end
	def yAligned? entity, positionX, positionY
		positionY - entity.posY + entity.height < DISTANCE_TOLERANCE &&
		positionY + self.height - entity.posY > -DISTANCE_TOLERANCE
	end

	def determineCollision entity, velocityX, velocityY
		case self.angle
		when :none
			determineStraightCollision? entity, velocityX, velocityY
		when :diagonal_tl_br
			if self.posX <= entity.posX ||
					self.posY >= (entity.posY + entity.height)
				determineStraightCollision entity, velocityX, velocityY
			end
			determine entity, velocityX, velocityY
		when :diagonal_tr_bl
		end
	end
	def determineStraightCollision entity, velocityX, velocityY
		col = Collision.new velocityX, velocityY

		if velocityX > 0
			tmpX = entity.posX - self.posX - self.width
			tmpY = velocityY * tmpX / velocityX
			if tmpX > -DISTANCE_TOLERANCE &&
					tmpX < velocityX &&
					self.yAligned?(entity, posX + tmpX, posY + tmpY)
				col.distanceX = tmpX
				col.inCollisionRight = true
				col.collisionX = entity
			end
		elsif velocityX < 0
			tmpX = entity.posX + entity.width - self.posX
			tmpY = velocityY * tmpX / velocityX
			if tmpX < DISTANCE_TOLERANCE &&
					tmpX > velocityX &&
					self.yAligned?(entity, posX + tmpX, posY + tmpY)
				col.distanceX = tmpX
				col.inCollisionLeft = true
				col.collisionX = entity
			end
		elsif velocityY > 0
			tmpY = entity.posY - self.posY - self.height
			tmpX = velocityX * tmpY / velocityY
			if tmpY > -DISTANCE_TOLERANCE &&
					tmpY < velocityY &&
					self.xAligned?(entity, posX + tmpX, posY + tmpY)
				col.distanceY = tmpY
				col.inCollisionTop = true
				col.collisionY = entity
			end
		elsif velocityY < 0
			tmpY = entity.posY + entity.height - self.posY
			tmpX = velocityX * tmpY / velocityY
			if tmpY < DISTANCE_TOLERANCE &&
					tmpY > velocityY &&
					self.xAligned?(entity, posX + tmpX, posY + tmpY)
				col.distanceY = tmpY
				col.inCollisionBottom = true
				col.collisionY = entity
			end
		end
	end
	def determine_tl_br_collision entity, velocityX, velocityY
		col = Collision.new velocityX, velocityY
		objRatio = entity.height / entity.width
		col.distanceX /= objRatio + 1

		tmp = entity.posY + entity.height +
			(objRatio *
			(self.posX + col.distanceX -
			(entity.posX + entity.width))) -
			self.posY + self.height - DISTANCE_TOLERANCE
		if tmp - col.distanceY < DISTANCE_TOLERANCE
			col.distanceY = tmp
			col.collisionY = entity
			col.inCollisionBottom = true
		end
		col
	end
	def determine_tr_bl_collision entity, velocityX, velocityY
		col = COllision.new velocityX, velocityY
		objRatio = entity.height / entity.width
		col.distanceX /= objRatio + 1

		tmp = entity.posY + entity.height -
			(objRatio *
			(self.getPosX + self.width + col.distanceX - entity.posX)) -
			self.posY + self.height - DISTANCE_TOLERANCE
		if tmp - col.distanceY < DISTANCE_TOLERANCE
			col.distanceY = tmp
			col.collisionY = entity
			col.inCollisionBottom = true
		end
		col
	end
	def shortestCollision col1, col2
		col = Collision.new 0, 0

		# X axis
		if col1.distanceX > 0 && col2.distanceX < col1.distanceX ||
				col1.distanceX < 0 && col2.distanceX > col.distanceX
			col.distanceX = col2.distanceX
			col.inCollisionLeft = col2.inCollisionLeft
			col.inCollisionRight = col2.inCollisionRight
			col.collisionX = col2.collisionX
		else
			col.distanceX = col1.distanceX
			col.inCollisionLeft = col1.inCollisionLeft
			col.inCollisionRight = col1.inCollisionRight
			col.collisionX = col1.collisionX
		end

		# Y axis
		if col1.distanceY > 0 && col2.distanceY < col1.distanceY ||
				col1.distanceY < 0 && col2.distanceY > col.distanceY
			col.distanceY = col2.distanceY
			col.inCollisionTop = col2.inCollisionTop
			col.inCollisionBottom = col2.inCollisionBottom
			col.collisionY = col2.collisionY
		else
			col.distanceY = col1.distanceY
			col.inCollisionTop = col1.inCollisionTop
			col.inCollisionBottom = col1.inCollisionBottom
			col.collisionY = col1.collisionY
		end
		col
	end

	def update delta, world
		self.applyWorldForces world.gravityX, world.gravityY, world.airFriction

		col = collision.new self.velocityX, self.velocityY

		# If the speed is 0, no need to check collisions
		if self.velocityX == 0 && self.velocityY == 0
			self.hasMoved = false
			self.lastCollision = col
			return
		end

		# Establish collision
		if self.collides
			world.spatialMap.get(self.aabb).each do |entity|
				if entity != self && entity.canBeCollided
					col = self.shortestCollision(col, determineCollision(entity, col.distanceX, col.distanceY))
				end
			end
		end
		positionX = self.positionX + col.distanceX
		positionY = self.positionY + col.distanceY
		if (!inCollision world, positionX, positionY)
			self.posX = positionX
			self.posY = positionY
		end

		self.resolveCollision col
		self.hasMoved = col.distanceX != 0 || col.distanceY != 0
		self.lastCollision = col
	end
	def applyWorldForces gravityX, gravityY, airFriction
		if self.gravitates
			self.velocityX += gravityX
			self.velocityY += gravityY
		end
		if self.isFrictionnal
			self.velocityX *= airFriction
			self.velocityY *= airFriction
		end
	end

	def resolveCollision col
		objsInCollision = Set.new

		# Y-axis
		if col.inCollisionBottom || col.inCollisionTop
			objsInCollision.add self
			# If there is an object to react to
			if col.collisionY != null
				objsInCollision.add col.collisionY
				self.velocityY *= -col.collisionY.reboundFactor
				self.velocityX *= col.collisionY.frictionFactor
			else # Otherwise just kill all speed
				self.velocityY = 0
			end
		end

		# X-axis
		if col.inCollisionRight || col.inCollisionLeft
			objsInCollision.add self
			# If there is an object to react to
			if col.collisionX != null
				objsInCollision.add col.collisionX
				# Check if there should be a step up to do
				if self.posY + self.height - STEP_MAXIMUM <= col.collisionX.posY
					tmp = (self.posY + self.height - col.collisionX.posY).abs
					self.velocityY = -(tmp + world.gravityY)
				else # Otherwise resolve the speed normally
					self.velocityX *= -col.collisionX.reboundFactor
					self.velocityY *= col.collisionX.frictionFactor
				end
			else # Otherwise just kill all speed
				self.velocityX = 0
			end
		end

		objsInCollision.each do |entity|
			entity.reactToCollision col
		end
	end
	def reactToCollision col

	end
end
