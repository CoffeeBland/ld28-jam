$engineDir = File.dirname(File.absolute_path(__FILE__)) + '/engine'

require "gosu"
Dir.glob($engineDir + "/**/*.rb").each do |file|
	require file
end
#require $engineDir + '/states/State'

class Game < Gosu::Window
	def initialize
		super 640, 480, false
		self.caption = 'Ludum Dare 28 engine prep'
		@time = Gosu::milliseconds
		@states = { 'InitState' => InitState.new  }
		self.switchTo 'InitState'
		
		@pressedInputs = Hash.new
	end
	
	def switchTo stateName
		unless @activeState.nil?
			@activeState.leave
		end
		@activeState = @states[stateName]
		@activeState.enter
	end
	
	def calculateDelta
		time = Gosu::milliseconds
		@delta = time - @time
		@time = time
		@delta
	end
	
	def update
		@pressedInputs.keys.each do |id| @activeState.down id end
		@activeState.update self.calculateDelta
	end
	
	def draw 
		@activeState.draw
	end
	
	def button_down id
		@activeState.press id
		@pressedInputs[id] = true
	end
	
	def button_up id
		@activeState.release id
		@pressedInputs.delete id
	end
end
Game.new.show