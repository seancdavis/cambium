class String
  def to_bool
    return true if self == true || self =~ (/^(true|t|yes|y|1)$/i)
    return false if self == false || self.blank? || self =~ (/^(false|f|no|n|0)$/i)
    raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
  end

  def possessive
    self + ('s' == self[-1, 1] ? "'" : "'s")
  end

  def paragraphs
    pattern = /\n/
    split(pattern).map(&:strip).reject(&:blank?)
  end

  def sentences
    pattern = /[\.\?\!]/
    punctuation = scan(pattern)
    sentences = split(pattern).map(&:strip).reject(&:blank?)
    return sentences if punctuation.blank?
    sentences.each_with_index do |txt, idx|
      next if punctuation[idx].blank?
      sentences[idx] += punctuation[idx]
    end
    sentences
  end
end
