module Engine
  module Utils
    class Z
      @@ranges = Hash.new
      def self.put_range key, count
        if @last_added.nil?
          min = 0
        else
          min = @@ranges[@last_added]
          min = min.last if min.is_a? Range
        end
        @@ranges[key] = min..min + count
        @last_added = key
      end
      def self.put_val key
        last = @@ranges[@last_added]
        last = last.last if last.is_a? Range
        @@ranges[key] = @last_added.nil? ? 0 : (last + 1)
        @last_added = key
      end
      self.put_range :entities, 10
      self.put_range :ui_nameplates, 1
      self.put_val :ui_speech_bubbles
      self.put_val :ui_health_bar
      self.put_val :ui_health
      self.put_val :debugging
      self.put_val :fade_in_out

      def self.[] key
        val = @@ranges[key]
        if val.is_a? Range
          rand() * (val.last - val.first) + val.first
        else
          val
        end
      end
    end
  end
end
