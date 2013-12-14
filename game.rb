ROOT_DIR = File.dirname(File.absolute_path(__FILE__))
RD = File.dirname(File.absolute_path(__FILE__)) + '/res'
$: << File.expand_path(File.dirname(__FILE__))

require "gosu"
(Dir.glob(ROOT_DIR + "/engine/**/*.rb") + Dir.glob(ROOT_DIR + "/ld28/**/*.rb")).each do |file|
  require file
end

class Game < Gosu::Window
  def initialize
    super 640, 480, false
    self.caption = 'Ludum Dare 28 engine prep'
    @time = Gosu::milliseconds

    @pressed_inputs = Hash.new

    @states = {
      :init => LD28::States::Logo.new(self),
      :menu => LD28::States::Menu.new(self),
      :castle => LD28::States::Castle.new(self)
    }
    self.switch_to :init

    Sounds.window = self
    init_sounds()

    Images.window = self
    init_images()

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

  def init_images
    Images[:logo] = File.join('res', 'images', 'logo.png')
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
