require "set"
require "engine/utils/spatial_map"

class World
  TILE_SIZE = 96
  attr_accessor :gravity_x
  attr_accessor :gravity_y
  attr_accessor :air_friction
  attr_reader :spatial_map
  attr_reader :entities

  def initialize
    @spatial_map = SpatialMap.new TILE_SIZE
    @entities = Set.new
    self.gravity_x = 0
    self.gravity_y = 0.1
    self.air_friction = 0.995
  end

  def update delta
    to_remove = Array.new
    self.entities.each do |entity|
      if entity.should_be_removed
        to_remove.push entity
      else
        entity.update delta, self
        if entity.collides && entity.has_moved
          self.spatial_map.update entity
        end
      end
    end
    to_remove.each do |entity|
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
  def reset
    @spatial_map = SpatialMap.new TILE_SIZE
    @entities = Set.new
  end

  def damage_point pos_x, pos_y, radius, source, damage
    self.spatial_map.within(pos_x, pos_y, radius).delete(source).each do |entity|
      entity.hit_for damage
    end
  end
end
