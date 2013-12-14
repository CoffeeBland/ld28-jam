require $engineDir + '/utils/SpatialMap'

class World
  attr_accessor :gravity_x
  attr_accessor :gravity_y
  attr_accessor :air_friction
  attr_reader :spatial_map
  attr_reader :entities

  def initialize
    @spatial_map = spatial_map.new
    @entities = Array.new
    self.gravity_x = 0
    self.gravity_y = 1
    self.air_friction = 0.995
  end

  def update delta
    toRemove = Array.new
    self.entites.each do |entity|
      if entity.should_be_removed
        toRemove.add entity
      else
        entity.update delta, self
        if entity.collisions && entity.has_moved
          self.spatial_map.update entity
        end
      end
    end
    toRemove.each do |entity|
      self.remove entity
    end
  end

  def draw camera
    self.spatial_map.get(camera).each do |entity|
      entity.draw camera
    end
  end

  def add entity
    self.entities.add entity
    self.spatial_map.put entity
  end
  def remove entity
    self.entities.delete entity
    self.spatial_map.remove entity
  end
end
