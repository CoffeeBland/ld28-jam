$: << File.expand_path(File.dirname(__FILE__))

# Require the engine and the game
ROOT_DIR = File.dirname(File.absolute_path(__FILE__))
require 'gosu'
(Dir.glob(ROOT_DIR + '/engine/**/*.rb') + Dir.glob(ROOT_DIR + '/ld28/**/*.rb')).each do |file|
  require file
end

# Get the settings passed to the game
ARGV.each do|a|
  p = a.split '='
  v = p.length >= 2 ? p[1] : true
  case v
    when 'true'
      v = true
    when 'false'
      v = false
    else
      v = v.to_i
  end
  Settings[p[0].to_sym] = v
end

# The game itself...
include Engine::Rendering

class Game < Gosu::Window
  # All the setup!
  def initialize
    # Ideally the width and the height would be dynamic
    @width = Settings[:width].is_a?(Numeric) ? Settings[:width] : Settings[:fullscreen] ? Gosu::screen_width : 640
    @height = Settings[:height].is_a?(Numeric) ? Settings[:height] : Settings[:fullscreen] ? Gosu::screen_height : 480

    # Deactivate anti-aliasing
    Gosu::enable_undocumented_retrofication
    super(@width, @height, (!Settings[:fullscreen].nil? && Settings[:fullscreen]))
    self.caption = 'Ludum Dare 28 : The One Kingdom'

    @time = Gosu::milliseconds
    @pressed_inputs = Hash.new

    Sounds.window = self
    init_sounds

    Images.window = self
    init_images

    Text.window = self
    init_fonts

    @states = {
      :init => LD28::States::Logo.new(self),
      :menu => LD28::States::Menu.new(self),
      :game => LD28::States::Game.new(self)
    }
    self.switch_to :init, 0x00000000, 1500
  end

  # Ressources intialisation
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

  def init_fonts
    Text.font = File.join('res', 'font.ttf')
  end

  # State management
  def switch_to(state_name, fade_color, duration)
    if @active_state.nil? # Switch right away
      @active_state = @states[state_name]
      @active_state.fade_in fade_color, duration
      @active_state.enter
    else # Do a fade out first
      @new_state = @states[state_name]
      @active_state.fade_out fade_color, duration
      @active_state.leave

      @until_switch = duration
      @switch_fade_color = fade_color
      @switch_duration = duration
    end
  end

  # Game routines
  def update
    delta = self.calculate_delta

    # Check for stage switch
    unless @until_switch.nil?
      @until_switch -= delta
      if @until_switch <= 0
        @until_switch = nil
        @active_state = @new_state
        @active_state.fade_in @switch_fade_color, @switch_duration
        @active_state.enter
      end
    end

    # Manage the inputs that are activated
    @pressed_inputs.keys.each do |id| @active_state.down id end

    # Update the current state
    @active_state.update delta
  end

  def draw
    @active_state.draw
  end

  def calculate_delta
    time = Gosu::milliseconds
    @delta = 16.6666666 #@delta = time - @time
    @time = time
    @delta
  end

  # Input dispatching
  def button_down(id)
    @active_state.press id
    @pressed_inputs[id] = true
  end

  def button_up(id)
    @active_state.release id
    @pressed_inputs.delete id
  end
end
Game.new.show
