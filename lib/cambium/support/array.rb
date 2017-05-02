class Array
  def average(attr = nil)
    return nil if size == 0
    unless attr.nil?
      return collect(&:"#{attr}").reject(&:nil?).sum.to_f / size.to_f
    end
    sum.to_f / size.to_f
  end
end
