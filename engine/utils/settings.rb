module Engine
  module Utils
    class Settings
      @@settings = Hash.new

      def self.[] key
        @@settings[key]
      end
      def self.[]= key, value
        @@settings[key] = value
      end
    end
  end
end
