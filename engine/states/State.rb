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
		@has_been_initialized = true
	end

	def enter
		unless @has_been_initialized
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
	def input_press id, function
		@press[id] = function
	end

	def release id
		unless @release[id].nil?
			@release[id].call
		end
	end
	def input_release id, function
		@release[id] = function
	end

	def down id
		unless @down[id].nil?
			@down[id].call
		end
	end
	def input_down id, function
		@down[id] = function
	end
end

class InitState < State
	def initialize
		super
		self.input_press Gosu::KbEscape, Proc.new {
			puts 'Escape!'
		}
		self.input_down Gosu::KbLeft, Proc.new {
			puts 'Left!'
		}
	end
end
