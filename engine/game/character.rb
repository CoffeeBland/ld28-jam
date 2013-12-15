require "engine/game/entity"
require "engine/utils/text"

class Character < Entity
  attr_reader :current_action

  def say speech
    @speech = speech
  end
  def speech
    @speech
  end

  def do action
    @current_action = action
  end

  def update delta, world
    if self.current_action != nil
      self.current_action.update delta, world, self

      if self.current_action.completed?
        @current_action = nil
      end
    end

    super delta, world
  end

  def draw camera
    super camera

    if self.speech != nil
      Text.draw_bubble @speech, self.pos_x + self.width / 2, self.pos_y, camera
    end
  end
end
