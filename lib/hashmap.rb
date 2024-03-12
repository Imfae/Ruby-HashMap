require_relative 'node'

class HashMap
  def initialize
    @capacity = 16
    @load_factor = 0.75
    @buckets = Array.new(@capacity)
    @length = 0
  end
  attr_accessor :length

  def hash(key)
    hash_code = 0
    prime = 19

    key.each_char {|char| hash_code = hash_code * prime + char.ord}
    hash_code = hash_code % (@capacity - 1)
  end
  
  def set(key, value)
    bucket_level = @buckets[hash(key)]
    until bucket_level.nil?
      if bucket_level.key == key
        @buckets[hash(key)].value = value
        return
      else
        bucket_level = @buckets[hash(key)].next_node
      end
    end
    if @buckets[hash(key)].nil?
      @buckets[hash(key)] = Node.new(key, value)
    else
      @buckets[hash(key)] = Node.new(key, value, @buckets[hash(key)])
    end
    @length += 1
    if @capacity * @load_factor < length
      @capacity += 1
      @buckets << nil
    end
  end

  def get(key)
    if @buckets[hash(key)]
      @buckets[hash(key)].value
    else
      nil
    end
  end

  def has(key)
    @buckets[hash(key)] ? true : false
  end

  def remove(key)
    if has(key)
      value = @buckets[hash(key)].value
      @buckets[hash(key)] = @buckets[hash(key)].next_node
      @length -= 1
      value
    else
      nil
    end
  end

  def clear
    @capacity = 16
    @buckets = Array.new(@capacity)
    @length = 0
  end

  def keys
    entries.map(&:first)
  end

  def values
    entries.map(&:last)
  end

  def entries
    entries_array = []
    buckets_iteration {|bucket| entries_array << [bucket.key, bucket.value]}
    entries_array
  end

  private

  def buckets_iteration
    @buckets.each do |bucket|
      until bucket.nil?
        yield(bucket)
        bucket = bucket.next_node
      end
    end
  end
end
