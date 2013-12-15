ROOT_DIR = File.dirname(File.absolute_path(__FILE__))
RD = File.dirname(File.absolute_path(__FILE__)) + '/res'
$: << File.expand_path(File.dirname(__FILE__))

require "gosu"
(Dir.glob(ROOT_DIR + "/engine/**/*.rb") + Dir.glob(ROOT_DIR + "/ld28/**/*.rb")).each do |file|
  require file
end

class Game < Gosu::Window
  # Not constants so when we find a way for it to be dynamic we can change them
  @@width = 480
  @@height = 480
  def self.width; @@width; end
  def self.height; @@height; end

  # All the setup!
  def initialize
    Gosu::enable_undocumented_retrofication
    super @@width, @@height, false
    self.caption = 'Ludum Dare 28 : The One Kingdom'

    @time = Gosu::milliseconds
    @pressed_inputs = Hash.new

    Sounds.window = self
    init_sounds()

    Images.window = self
    init_images()

    Text.window = self
    init_font()

    @states = {
      :init => LD28::States::Logo.new(self),
      :menu => LD28::States::Menu.new(self),
      :game => LD28::States::Game.new(self)
    }
    self.switch_to :init
  end

  def init_sounds
    Sounds[:bg1] = File.join('res', 'sounds', 'horrorambient.ogg')
  end

  def init_images
    Images[:logo] = File.join('res', 'images', 'logo.png')
    Images[:desert_bg] = File.join('res', 'images', 'desert.png')
    Images[:castle] = File.join('res', 'images', 'suchcastle.png')
    Images[:gate] = File.join('res', 'images', 'suchgate.png')
    Images[:tile1] = File.join('res', 'images', 'tile1.png')
    Images[:tile2] = File.join('res', 'images', 'tile2.png')
    Images[:health_bar_container] = File.join('res', 'images', 'health_bar_container.png')
  end

  def init_font
    Text.font = File.join('res', 'font.ttf')
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
