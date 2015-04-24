class Hash

  def to_ostruct
    convert_to_ostruct_recursive(self)
  end

  private

    def convert_to_ostruct_recursive(obj)
      result = obj
      if result.is_a? Hash
        result = result.dup.symbolize_keys
        result.each  do |key, val|
          result[key] = convert_to_ostruct_recursive(val)
        end
        result = OpenStruct.new(result)
      elsif result.is_a? Array
        result = result.map { |r| convert_to_ostruct_recursive(r) }
      end
      result
    end

end
