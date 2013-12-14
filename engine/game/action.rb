class Cue
  attr_reader :time_left
  attr_reader :act

  def initialize time_left, act
     @time_left = time_left
     @act = act
  end
end

class Action
  attr_reader :cues
  attr_reader :current_cue
  attr_reader :time_left

  def initialize duration, cues
    self.time_left = duration
    self.cues = cues
  end

  def next_cue
    if self.cues.peek.time >= self.time_left
      self.current_cue = self.cues.pop
    else
      nil
  end

  def completed?
    self.time_left < 0
  end

  def update delta, world, source
    @time_left -= value

    while self.next_cue
      self.current_cue.act world source
    end
  end
end
