require "set"

Coord = Struct.new(:x,:y)

class SpatialMap

  def initialize tile_size = 96
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
        pos = Coord.new(x, y)
        elements = @map[pos]
        if elements == nil
          elements = Array.new
          @map[pos] = elements
        end
        elements.push object
      end
    end
  end

  def remove object
    tiles = @objects.delete object
    tiles[0].step @tile_size do |x|
      tiles[1].step @tile_size do |y|
        pos = Coord.new(x, y)
        objects = @map[pos]
        objects.delete object
        if objects.length == 0
          @map[pos].delete objects
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
        tmp_cord = @map[Coord.new(x, y)]
        objects.merge tmp_cord unless tmp_cord.nil?
      end
    end
    objects
  end

  def within pos_x, pos_y, radius
    objects = Set.new
    range_x = pos_x - radius..pos_x + radius
    range_y = pos_y - radius..pos_y + radius
    radius_squared = radius**2
    range_x.step @tile_size do |x|
      range_y.step @tile_size do |y|
        #get objects in tile
        @map[Coord.new(x, y)].each do |entity|
          [ #for each corner of the object
            [entity.pos_x, entity.pos_y], #top left
            [entity.pos_x + entity.width, entity.pos_y], #top right
            [entity.pos_x, entity.pos_y + entity.height], #bottom left
            [entity.pos_x + entity.width, entity.pos_y + entity.height] #bottom right
          ].each do |point|
            #if it is in range, add it to the set
            if (point[0] - pos_x)**2 + (point[1] - pos_y)**2 < radius_squared
              objects.add entity
              return
            end
          end
        end
      end
    end
    objects
  end
end
