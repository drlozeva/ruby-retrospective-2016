  class UnknownAttributeError < StandardError
  end

  class DeleteUnsavedRecordError < StandardError
  end

  module DataModeClassMethods
    attr_reader :store

    def attributes(*attrs)
      return @attributes if attrs.empty?
      attrs |= [:id]
      @attributes = attrs

      attrs.each do |name|
        define_method(name) { @changed_values[name] }
        define_method("#{name}=") { |val| @changed_values[name] = val }
        define_singleton_method("find_by_#{name}") do |val|
          @store.find(name => val).map { |o| new(o) }
        end
      end
    end

    def save_hashes
      saved = {}
      @objects.each_with_index { |item, index| saved[index + 1] = item }
    end

    def data_store(store = nil)
      return @store if store.nil?
      @store = store
    end

    def where(params)
      params.each do |k, _v|
        unless attributes.include?(k)
          raise DataModel::UnknownAttributeError, "Unknown attribute #{k}"
        end
      end

      @store.find(params).map { |o| new(o) }
    end
  end

  def first_name
    @changed_values[name]
  end

  def initialize(args = {})
    @values = {}
    @changed_values = {}
    args.each do |key, value|
      if self.class.attributes.include?(key)
        @changed_values[key] = value
        @values[key] = value
      end
    end
  end

class DataModel
  extend DataModeClassMethods

  def save
    @changed_values.each { |key, value| @values[key] = value }
    id = self.class.store.create(@values)
    @values[:id] = id
    @changed_values[:id] = id
    self
  end

  def delete
    raise DataModel::DeleteUnsavedRecordError if @values[:id].nil?
    self.class.store.delete(@values)
    self
  end

  def attributes
    @changed_values
  end

  def changed_attributes
    @changed_values
  end

  def changed_attributes=(new_value)
    @changed_values = new_value
  end

  def data_store
    self.class.data_store
  end

  def ==(other)
    if self.id.nil? || other.id.nil?
      self.equal?(other)
    else
      self.id == other.id
    end
  end
end

class HashStore
  attr_reader :storage

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

    object[:id]
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
    @objects.delete_if do |_k, v|
      params.all? do |key, value|
        v[key] == value
      end
    end
  end
end

class ArrayStore
  attr_reader :storage

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
