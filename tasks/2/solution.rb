class Hash
  def fetch_deep(path)
    path.split('.').reduce(self) do |memo, key|
      memo == nil ? nil : memo[key.to_i] || memo[key.to_sym] || memo[key]
    end
  end

  def reshape(shape)
    return fetch_deep(shape) if shape.is_a? String
    my_new_hash = {}
    my_new_hash.merge!(shape)
    my_new_hash.map do |key, value|
      my_new_hash[key] = reshape(value)
    end
    my_new_hash
  end
end
class Array
  def reshape(shape)
    map { |element| element.reshape(shape) }
  end
end
