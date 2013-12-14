ED = File.dirname(File.absolute_path(__FILE__)) + '/engine'
GD = File.dirname(File.absolute_path(__FILE__)) + '/ld28'

require "gosu"
Dir.glob(ED + "/**/*.rb").each do |file|
  puts file[file.rindex(/\//)..-1]
  require file
end
Dir.glob(GD + "/**/*.rb").each do |file|
  require file
end

class Game < Gosu::Window
  def initialize
    super 640, 480, false
    self.caption = 'Ludum Dare 28 engine prep'
    @time = Gosu::milliseconds

    @pressed_inputs = Hash.new

    @states = {
      :init => LD28::States::Init.new,
      :menu => LD28::States::Menu.new,
      :castle => LD28::States::Castle.new
    }
    self.switch_to :init

    Sounds.window = self
    init_sounds()

    # volume=1, speed=1, loop=true
    # sound1inst = Sounds[:bg1].play(1, 0.3, true)
    # you get back a sample instance that has:
    # sound1inst.pause
    # sound1inst.paused?
    # sound1inst.playing?
    # sound1inst.resume
    # sound1inst.stop
  end

  def init_sounds
    Sounds[:bg1] = File.join('res', 'sounds', 'horrorambient.ogg')
  end

  def switch_to state_name
    unless @active_state.nil?
      @active_state.leave
    end
    @active_state = @states[state_name]
    @active_state.enter
  end

  def calculate_delta
    time = Gosu::milliseconds
    @delta = time - @time
    @time = time
    @delta
  end

  def update
    @pressed_inputs.keys.each do |id| @active_state.down id end
    @active_state.update self.calculate_delta
  end

  def draw
    @active_state.draw
  end

  def button_down id
    @active_state.press id
    @pressed_inputs[id] = true
  end

  def button_up id
    @active_state.release id
    @pressed_inputs.delete id
  end
end
Game.new.show
