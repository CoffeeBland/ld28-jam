class Cue
  attr_reader :time_left
  attr_reader :act

  def act world, source
     @action.call world, source
  end

  def initialize time_left, act
     @time_left = time_left
     @action = act
  end
end

class Action
  attr_reader :cues
  attr_reader :current_cue
  attr_reader :time_left

  def initialize duration, cues
    @time_left = duration
    @cues = cues
  end

  def next_cue
    if self.cues[-1] != nil && self.cues[-1].time_left >= self.time_left
      @current_cue = self.cues.pop
    else
      nil
    end
  end

  def completed?
    self.time_left < 0
  end

  def update delta, world, source
    @time_left -= delta

    while self.next_cue != nil
      self.current_cue.act world, source
    end
  end
end
