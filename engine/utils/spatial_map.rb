require "set"

Coord = Struct.new(:x,:y)

class SpatialMap

  def initialize tile_size = 96
    @tile_size = tile_size
    @map = Hash.new
    @objects = Hash.new
  end
  def low_clamp value
    (value.to_f / @tile_size).floor * @tile_size
  end
  def high_clamp value
    (value.to_f / @tile_size).ceil * @tile_size
  end
  def put object
    left = self.low_clamp(object.pos_x)
    right = self.high_clamp(object.pos_x + object.width)
    top = self.low_clamp(object.pos_y)
    bottom = self.high_clamp(object.pos_y + object.height)
    range_x = left..right
    range_y = top..bottom

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
    unless tiles.nil?
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
  end

  def update object
    self.remove object
    self.put object
  end

  def get region
    left = self.low_clamp(region.pos_x)
    right = self.high_clamp(region.pos_x + region.width)
    top = self.low_clamp(region.pos_y)
    bottom = self.high_clamp(region.pos_y + region.height)
    range_x = left..right
    range_y = top..bottom

    objects = Set.new
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
    range_x = self.low_clamp(pos_x - radius)..self.high_clamp(pos_x + radius)
    range_y = self.low_clamp(pos_y - radius)..self.high_clamp(pos_y + radius)
    radius_squared = radius**2
    range_x.step @tile_size do |x|
      range_y.step @tile_size do |y|
        #get objects in tile
        @map[Coord.new(x, y)].each do |entity|
          if pos_x > entity.pos_x - radius && pos_x < entity.pos_x + entity.width + radius &&
              pos_y > entity.pos_y && pos_y < entity.pos_y + entity.height ||
              pos_x > entity.pos_x && pos_x < entity.pos_x + entity.width &&
              pos_y > entity.pos_y - radius && pos_y < entity.pos_y + entity.height + radius
            objects.add entity
          else
            [ #for each corner of the object
              [entity.pos_x, entity.pos_y], #top left
              [entity.pos_x + entity.width, entity.pos_y], #top right
              [entity.pos_x, entity.pos_y + entity.height], #bottom left
              [entity.pos_x + entity.width, entity.pos_y + entity.height] #bottom right
            ].each do |point|
              #if it is in range, add it to the set
              if (point[0] - pos_x)**2 + (point[1] - pos_y)**2 < radius_squared
                objects.add entity
                break
              end
            end
          end
        end
      end
    end
    objects
  end
end
