require "engine/utils/aabb"
require "engine/rendering/images"

module Engine
	module Rendering
		class ImageSheet < AABB
			# Rendering properties
			attr_accessor :tiles
			attr_accessor :z_index
			attr_accessor :color
			attr_accessor :reverse

			# Animation properties
			def frames_per_second
				@frames_per_second
			end
			def frames_per_second= val
				@frames_per_second = val
				if val.nil?
					@frame_duration = nil
				else
					@frame_duration = 1000 / val
				end
			end
			def frame_duration
				@frame_duration
			end
			def frame_duration= val
				@frame_duration = val
				if val.nil?
					@frames_per_second = nil
				else
					@frames_per_second = 1000 / val
				end
			end
			attr_accessor :frameTime
			attr_accessor :is_repeating

			# Tiling accessors
			def tile_x
				@tile_x
			end
			def tile_x= val
				@tile_x = val
				while @tile_x < 0
					@tile_x += self.tiles_x
				end
				if self.is_repeating
					if @tile_x >= self.tiles_x
						@tile_x -= self.tiles_x
					end
				else
					while @tile_x >= self.tiles_x
						@tile_x = self.tiles_x - 1
					end
				end
			end

			def tile_y
				@tile_y
			end
			def tile_y= val
				@tile_y = val
				while @tile_y < 0
					@tile_y += self.tiles_y
				end
				while @tile_y >= self.tiles_y
					@tile_y -= self.tiles_y
				end
			end

			# Utility accessors
			def tiles_x
				@tiles_x
			end
			def tiles_y
				@tiles_y
			end

			def initialize imagePath, tileWidth, tileHeight, options = Hash.new
				if Images[imagePath] == nil
					@tiles = Images.add(
						imagePath,
						Gosu::Image.load_tiles_square(Images.window, imagePath, tileWidth, tileHeight, true)
					)
				else
					@tiles = Images[imagePath]
				end
				@tile_x = 0
				@tile_y = 0
				@tiles_x = @tiles.length
				@tiles_y = @tiles[0].length
				@pos_x = 0
				@pos_y = 0
				@width = tileWidth
				@height = tileHeight
				@color = 0xffffffff
				@z_index = options[:z_index].nil? ? 0 : options[:z_index]
				@reverse = 1

				self.is_repeating = options[:is_repeating].nil? ? true : options[:is_repeating]
				if options[:frames_per_second] != nil
					self.frames_per_second = options[:frames_per_second]
					self.frameTime = self.frame_duration
				elsif options[:frame_duration] != nil
					self.frame_duration = options[:frame_duration]
					self.frameTime = self.frame_duration
				end
			end

			def update delta
				unless self.frame_duration.nil? or self.frame_duration <= 0
					self.frameTime -= delta
					while self.frameTime < 0
						self.frameTime += self.frame_duration
						self.tile_x += 1
					end
				end
			end

			def draw camera, z_decal = 0
				self.tiles[self.tile_x][self.tile_y].draw(
					(self.pos_x - camera.pos_x + (@width * -(self.reverse - 1) / 2)).round,
					(self.pos_y - camera.pos_y).round,
					self.z_index + z_decal, self.reverse, 1, self.color
					)
			end
		end
	end
end
