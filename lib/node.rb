class Node
  def initialize(key, value, next_node = nil)
    @key = key
    @value = value
    @next_node = next_node
  end
  attr_accessor :key, :value, :next_node
end