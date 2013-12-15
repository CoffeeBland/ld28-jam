require "engine/game/particle"
require "engine/rendering/image_sheet"

class Smoke < Particle
  @@width = 24
  @@height = 24
  @@gravitates = false
  @@collides = false
  @@can_be_collided = false
  @@frame_duration = 32
  @@duration = @@frame_duration * 6
  @@frame_repeat = false
  @@file = File.join('res', 'images', 'smoke.png')

  def initialize pos_x, pos_y
    super (pos_x - @@width / 2), (pos_y - @@height / 2),
      @@width, @@height, {
      :image_sheet => ImageSheet.new(@@file, @@width, @@height, {
          :frame_duration => @@frame_duration,
          :is_repeating => @@frame_repeat
        }),
      :collides => @@collides,
      :gravitates => @@gravitates,
      :can_be_collided => @@can_be_collided,
      :duration => @@duration
      }
  end
end
