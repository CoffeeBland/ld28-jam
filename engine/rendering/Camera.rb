require $engineDir + '/utils/AABB'

class Camera < AABB
	def center_on entity
		self.posX = entity.posX + entity.width / 2 - self.width / 2
		self.posY = entity.posY + entity.height / 2 - self.height / 2
	end
end
