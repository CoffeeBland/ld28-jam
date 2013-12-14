require $engineDir + '/game/Entity'

class Particle < Entity
  attr_accessor :explodesOnContact

  def initialize posX, posY, width, height, options = Hash.new
    super posX, posY, width, height, options

    self.explodesOnContact = options[:explodesOnContact].nil? ? true : options[:explodesOnContact]
  end

  def update delta, world
    super delta, world
    self.health -= delta
  end

  def reactToCollision col
    super col

    if self.explodesOnContact
      self.die
    end
  end
end
