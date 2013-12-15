require "engine/game/action"
require "ld28/sfx/hit"
require "pp"

class Punch < Action
  def initialize
    super 400, [
      Cue.new(400, Proc.new { |world, source|
          @multiplier = source.facing == :left ? 0 : 1
          @img_repeats = source.image_sheet.is_repeating
          @img_fduration = source.image_sheet.frame_duration
          source.image_sheet.is_repeating = false
          source.image_sheet.frame_duration = nil
          source.image_sheet.tile_x = 0
          source.image_sheet.tile_y = 4 + (source.image_sheet.tiles_y / 2) * @multiplier
        }
      ),
      Cue.new(300, Proc.new { |world, source|
          source.image_sheet.tile_x = 1
          source.velocity_y -= 0.5
          source.velocity_x -= 1 * (@multiplier - 0.5)
        }
      ),
      Cue.new(200, Proc.new { |world, source|
          source.image_sheet.tile_x = 2
          source.velocity_y -= 0.5
          source.velocity_x += 3 * (@multiplier - 0.5)
        }
      ),
      Cue.new(100, Proc.new { |world, source|
          source.image_sheet.tile_x = 3
          x = source.pos_x + source.width * @multiplier + (6 * (@multiplier - 0.5))
          y = source.pos_y + source.height - 14
          world.damage_point(x, y, 4, source, 5).each do |entity|
            if entity.collides
              entity.velocity_x += 5 * (@multiplier - 0.5)
              entity.velocity_y -= 2
            end
          end
          world.add Hit.new x, y
        }
      ),
      Cue.new(000, Proc.new { |world, source|
          source.image_sheet.is_repeating = @img_repeats
          source.image_sheet.frame_duration = @img_fduration
        }
      )
    ].reverse
  end
end
