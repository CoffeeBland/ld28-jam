require 'engine/game/action'

module LD28
	module Actions
		class Interact < Engine::Game::Action 
			DURATION = 400
    	CUES = [
        Cue.new(1, Proc.new { |world, source|
            @multiplier = source.facing == :left ? 0 : 1
            @img_repeats = source.image_sheet.is_repeating
            @img_fduration = source.image_sheet.frame_duration
            source.image_sheet.is_repeating = false
            source.image_sheet.frame_duration = nil
            source.image_sheet.tile_x = 3
            source.image_sheet.tile_y = 1
          }
        ),
        Cue.new(0.75, Proc.new { |world, source|
            source.image_sheet.tile_x = 0
            source.image_sheet.tile_y = 1
          }
        ),
        Cue.new(0.5, Proc.new { |world, source|
            source.image_sheet.tile_x = 1
            source.image_sheet.tile_y = 1
          }
        ),
        Cue.new(0.25, Proc.new { |world, source|
            source.image_sheet.tile_x = 0
            source.image_sheet.tile_y = 2
          }
        ),
        Cue.new(0, Proc.new { |world, source|
            source.image_sheet.is_repeating = @img_repeats
            source.image_sheet.frame_duration = @img_fduration
          }
        )
      ].reverse
	  def initialize
	    super DURATION, CUES.clone
	  end
		end
	end
end