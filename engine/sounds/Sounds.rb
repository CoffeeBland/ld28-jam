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
