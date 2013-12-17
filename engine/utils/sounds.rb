
# sound.play volume=1, speed=1, loop=true
# sound1inst = Sounds[:bg1].play(1, 0.3, true)
# you get back a sample instance that has:
# sound1inst.pause
# sound1inst.paused?
# sound1inst.playing?
# sound1inst.resume
# sound1inst.stop
module Engine
  module Utils
    class Sounds
      @@sounds = Hash.new
      @@window = nil

      def self.window= obj
        @@window = obj
      end

      def self.[] key
        @@sounds[key]
      end

      def self.[]= key, path
        @@sounds[key] = Gosu::Sample.new(@@window, path)
      end

      def self.add key, val
        @@sounds[key] = val
      end
    end
  end
end
