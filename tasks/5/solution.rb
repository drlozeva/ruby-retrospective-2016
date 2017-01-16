class DataModel
  class << self
    attr_reader :store
    def attributes(*attrs)
      @attributes = attrs
      attrs.each do |name|
        define_method(name) { @changed_values[name] }
        define_method("#{name}=") { |val| @changed_values[name] = val }
        define_singleton_method("find_by_#{name}") { |val| @store.find(name => val) }
      end
    end
    def attrs
      @attributes
    end
    def save_hashes
      saved = {}
      @objects.each_with_index { |item, index| saved[index + 1] = item }
    end
    def data_store(store)
      @store = store
    end
    def where(params)
      @store.find(params)
    end
  end
  def initialize(args = {})
    @values = {}
    @changed_values = {}
    args.each { |key, value| @values[key] = value if User.attrs.include?(key) }
  end
  def save
    @changed_values.each { |key, value| @values[key] = value }
    self.class.store.create(@values)
    @changed_values = {}
    self
  end
  def delete
    self.class.store.delete(@values)
    self
  end
  def attributes
    @values.merge(@changed_values)
  end
  def changed_attributes
    @changed_values
  end
  def changed_attributes=(new_value)
    @changed_values = new_value
  end
end
class HashStore
  def initialize
    @id = 0
    @objects = {}
  end
  def getter
    @objects
  end
  def id
    @id += 1
  end
  def create(object)
    existing = find(object).first
    if existing
      update(existing[:id], object)
    else
      object[:id] ||= id
      @objects[object[:id]] = object
    end
  end
  def find(params)
    objects = @objects
    objects.select do |_k, v|
      params.all? do |key, value|
        v[key] == value
      end
    end.values
  end
  def update(id, params)
    obj = find({ id: id }).first
    params.each do |key, value|
      obj[key] = value
    end
  end
  def delete(params)
    @objects.delete_if do |k, _v|
      params.all? do |key, value|
        k[key] == value
      end
    end
  end
end
class ArrayStore
  def initialize
    @id = 0
    @objects = []
  end
  def getter
    @objects
  end
  def id
    @id += 1
  end
  def create(object)
    existing = find(object).first
    if existing
      update(existing[:id], object)
    else
      object[:id] ||= id
      @objects << object
    end
  end
  def find(params)
    objects = @objects
    objects.select do |obj|
      params.all? do |key, value|
        obj[key] == value
      end
    end
  end
  def update(id, params)
    obj = find({ id: id }).first
    params.each do |key, value|
      obj[key] = value
    end
  end
  def delete(params)
    @objects.delete_if do |obj|
      params.all? do |key, value|
        obj[key] == value
      end
    end
  end
end
