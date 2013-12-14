require "engine/game/entity"

class Character < Entity
  attr_reader :current_action
  def say speech
    @speech = speech
  end
  def saying
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
    super.draw camera
  end
end
