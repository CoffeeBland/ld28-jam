class Images
  @@images = Hash.new
  @@window = nil

  def self.window= obj
    @@window = obj
  end

  def self.[] key
    @@images[key]
  end

  def self.[]= key, path
    @@images[key] = Gosu::Image.new(@@window, path, false)
  end

  def self.add key, val
    @@images[key] = val
  end
end
