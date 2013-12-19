require 'engine/game/action'
require 'ld28/sfx/hit'

module LD28
  module Actions
    class Punch < Engine::Game::Action
      DURATION = 500
      CUES = [
          Cue.new(1, Proc.new { |world, source|
              @multiplier = source.facing == :left ? 0 : 1
              @img_repeats = source.image_sheet.is_repeating
              @img_fduration = source.image_sheet.frame_duration
              source.image_sheet.is_repeating = false
              source.image_sheet.frame_duration = nil
              source.image_sheet.tile_x = 0
              source.image_sheet.tile_y = 4
            }
          ),
          Cue.new(0.75, Proc.new { |world, source|
              source.image_sheet.tile_x = 1
              source.velocity_y -= 0.75
              source.velocity_x -= 3 * (@multiplier - 0.5)
            }
          ),
          Cue.new(0.5, Proc.new { |world, source|
              source.image_sheet.tile_x = 2
              source.velocity_y -= 0.75
              source.velocity_x += 6 * (@multiplier - 0.5)
              x = source.pos_x + source.width * @multiplier + (source.weapon.length * (@multiplier - 0.5)) * 2
              y = source.pos_y + source.height - 14
              world.damage_point(x, y, 6, source, 5).each do |entity|
                entity.velocity_x += 5 * (@multiplier - 0.5)
                entity.velocity_y -= 2
              end
            }
          ),
          Cue.new(0.375, Proc.new { |world, source|
              x = source.pos_x + source.width * @multiplier + (source.weapon.length * (@multiplier - 0.5)) * 2
              y = source.pos_y + source.height - 14
              world.damage_point(x, y, 6, source, 5).each do |entity|
                entity.velocity_x += 5 * (@multiplier - 0.5)
                entity.velocity_y -= 2
              end
            }
          ),
          Cue.new(0.25, Proc.new { |world, source|
              source.image_sheet.tile_x = 3
              source.display_weapon_behind = true
              x = source.pos_x + source.width * @multiplier + (source.weapon.length * (@multiplier - 0.5)) * 2
              y = source.pos_y + source.height - 14
              world.damage_point(x, y, 6, source, 5).each do |entity|
                entity.velocity_x += 5 * (@multiplier - 0.5)
                entity.velocity_y -= 2
              end
              world.add Hit.new x, y
            }
          ),
          Cue.new(0, Proc.new { |world, source|
              source.image_sheet.is_repeating = @img_repeats
              source.image_sheet.frame_duration = @img_fduration
              source.display_weapon_behind = false
            }
          )
        ].reverse

      def initialize
        super DURATION, CUES.clone
      end
    end
  end
end