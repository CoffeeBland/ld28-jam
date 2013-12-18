require "set"
require "engine/physics/spatial_map"
require "pp"
require "engine/game/character"

module Engine
  module Game
    class World
      TILE_SIZE = 96
      attr_accessor :gravity_x
      attr_accessor :gravity_y
      attr_accessor :air_friction
      attr_reader :spatial_map
      attr_reader :entities
      attr_accessor :to_add

      def initialize
        @spatial_map = SpatialMap.new TILE_SIZE
        @entities = Set.new
        self.gravity_x = 0
        self.gravity_y = 0.3
        self.air_friction = 0.95
        self.to_add = Array.new
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
        self.to_add.each do |entity|
          self.entities.add entity
          self.spatial_map.put entity
        end
        self.to_add.clear
      end

      def draw camera
        self.spatial_map.get(camera).each do |entity|
          entity.draw camera
        end
      end

      def add entity
        self.to_add.push entity
      end
      def remove entity
        self.entities.delete entity
        self.spatial_map.remove entity
      end
      def reset
        @spatial_map = SpatialMap.new TILE_SIZE
        @entities = Set.new
        self.to_add.clear
      end

      def damage_point pos_x, pos_y, radius, source, damage
        objs = self.spatial_map.within(pos_x, pos_y, radius).delete(source)
        objs.each do |entity|
          unless entity.is_a?(Character) && entity.damaged_duration > 0
            entity.hit_for damage, self
          end
        end
        objs
      end

      def check_for_door_with player
        self.entities.each do |e|
          if e.is_a?(GhostDoor) && e.overlaps?(player)
            e.react_to_character player, self
          end
        end
      end
    end
  end
end
