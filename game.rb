$engineDir = File.dirname(File.absolute_path(__FILE__)) + '/engine'

require "gosu"
Dir.glob($engineDir + "/**/*.rb").each do |file|
	require file
end

class Game < Gosu::Window
	def initialize
		super 640, 480, false
		self.caption = 'Ludum Dare 28 engine prep'
		@time = Gosu::milliseconds

		@pressed_inputs = Hash.new
		@states = { :init_state => InitState.new  }
		self.switch_to :init_state

		Sounds.window = self
		Sounds.add(:bg1, 'res/sounds/bulgarish_vln.mp3')

		# volume=1, speed=1, loop=true
		sound1inst = Sounds[:bg1].play(1, 0.3, true)
		# you get back a sample instance that has:
		# sound1inst.pause
		# sound1inst.paused?
		# sound1inst.playing?
		# sound1inst.resume
		# sound1inst.stop
	end

	def switch_to stateName
		unless @active_state.nil?
			@active_state.leave
		end
		@active_state = @states[stateName]
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
