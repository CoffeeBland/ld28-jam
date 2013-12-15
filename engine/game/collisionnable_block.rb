class CollisionnableBlock < Entity
  BLOCK_OPTIONS = {:gravitates => false, :collides => false, :rebound_factor_y => 0}

  def initialize pos_x, pos_y, width, height, options = Hash.new
    super pos_x, pos_y, width, height, BLOCK_OPTIONS.merge(options)
  end

end
