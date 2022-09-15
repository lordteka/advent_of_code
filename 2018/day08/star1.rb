class Node
  def initialize(header_index)
    @header = {
      children_number: TREE[header_index],
      metadata_number: TREE[header_index + 1]
    }
    @body_index = header_index + 2
  end

  def build_children_grab_metadata
    ptr = @body_index
    @children = []
    @header[:children_number].times do
      @children << Node.new(ptr)
      ptr = @children.last.build_children_grab_metadata
    end
    @metadata = TREE[ptr...ptr + @header[:metadata_number]]
    ptr + @header[:metadata_number]
  end

  def metadata_sum
    @children.reduce(@metadata.sum) { |acc, c| acc += c.metadata_sum }
  end
end

TREE = File.read('input').chomp.split(' ').map &:to_i
root = Node.new(0)
root.build_children_grab_metadata
p root.metadata_sum
