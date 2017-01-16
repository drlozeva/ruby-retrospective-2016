class Hash
  def fetch_deep(path, hash = self)
    return hash if hash.nil? || path.nil?
    key, path = path.split(".", 2)
    return fetch_deep(path, hash[key]) if hash.key?(key)
    return fetch_deep(path, hash[key.to_sym]) if hash.key?(key.to_sym)
  end
  def reshape(shape)
    my_new_hash = {}
    my_new_hash.merge!(shape)
    my_new_hash.each { |key, value| my_new_hash[key] = fetch_deep(value) }
    my_new_hash
  end
end
