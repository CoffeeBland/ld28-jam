require "engine/game/character"

class Door < Entity

  def initialize pos_x, pos_y, width, height, options = Hash.new, action = Proc.new
    super pos_x, pos_y, width, height, options
    self.class.send(:define_method, :react_to_collision) do |sender, col, world|
      action.call(sender, col, world) if sender.is_a?(Character)
    end
  end

end
