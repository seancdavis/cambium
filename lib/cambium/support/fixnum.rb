class Fixnum

  def nearest_half
    to_f.nearest_half
  end

  def to_bool
    return true if self == 1
    return false if self == 0
    raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
  end

end
