class State
  def initialize
    @press = Hash.new
    @release = Hash.new
    @down = Hash.new
  end

  def update delta
    raise "Implement update in game state #{self.class.name}"
  end

  def draw
    raise "Implement draw in game state #{self.class.name}"
  end

  def init
    @has_been_initialized = true
    raise "Implement init in game state #{self.class.name}"
  end

  def enter
    unless @has_been_initialized
      self.init
    end
  end

  def leave
  end

  def press id
    unless @press[id].nil?
      @press[id].call
    end
  end
  def input_press id, function
    @press[id] = function
  end

  def release id
    unless @release[id].nil?
      @release[id].call
    end
  end
  def input_release id, function
    @release[id] = function
  end

  def down id
    unless @down[id].nil?
      @down[id].call
    end
  end
  def input_down id, function
    @down[id] = function
  end
end
