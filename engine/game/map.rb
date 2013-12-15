class Map
  def initialize
    @background = 0xEE00EEFF
  end

  def update state, tick
  end

  def draw state, game
    state.set_color @background
    state.draw_rect 0, 0, state.game.width, state.game.height
  end

  def enter state
  end

  def leave state
  end

end
