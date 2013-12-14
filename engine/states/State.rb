class State
	def initialize
		@press = Hash.new
		@release = Hash.new
		@down = Hash.new
	end

	def update delta
	end
	
	def draw
	end
	
	def init
		@hasBeenInitialized = true
	end
	
	def enter
		unless @hasBeenInitialized
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
	def inputPress id, function
		@press[id] = function
	end
	
	def release id
		unless @release[id].nil?
			@release[id].call
		end
	end
	def inputRelease id, function
		@release[id] = function
	end
	
	def down id
		unless @down[id].nil?
			@down[id].call
		end
	end
	def inputDown id, function
		@down[id] = function
	end
end

class InitState < State
	def initialize
		super
		self.inputPress Gosu::KbEscape, Proc.new {
			puts 'Escape!'
		}
		self.inputDown Gosu::KbLeft, Proc.new {
			puts 'Left!'
		}
	end
end