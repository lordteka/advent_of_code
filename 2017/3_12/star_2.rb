class SpiralArray
  class State
    STATES = [:right, :up, :left, :down]

    def initialize
      @i = 0
    end

    def next
      @i = (@i + 1) % 4
    end

    def current
      STATES[@i]
    end
  end

  attr_reader :spiral_array

  def initialize(size)
    @spiral_array = [[1]]
    @edge_size = 2
    @state = State.new
    @current_row = 0
    @change_state = 0
    @current_edge_len = 1

    (2..size).each do |_|
      add_nb
    end
  end

  def change_state
    @current_edge_len += 1
    if @current_edge_len == @edge_size
      @state.next
      @change_state += 1
      @edge_size += 1 if @change_state % 2 == 0
      @current_edge_len = 1
    end
  end

  def adj_sum
    case @state.current
    when :right
      sum = [@spiral_array[@current_row][@current_edge_len - 1]]
      sum << @spiral_array[@current_row - 1][@current_edge_len - 1] << @spiral_array[@current_row - 1][@current_edge_len] << @spiral_array[@current_row - 1][@current_edge_len + 1] if @current_row > 0
    when :up
      sum = [@spiral_array[@current_row][-1]]
      sum << @spiral_array[@current_row - 1][-1] if @current_row > 0
      sum << @spiral_array[@current_row + 1][-1] << @spiral_array[@current_row + 1][-2]
    when :left
      sum = [@spiral_array[@current_row][0]]
      sum << @spiral_array[@current_row + 1][-@current_edge_len] << @spiral_array[@current_row + 1][-(@current_edge_len + 1)] << @spiral_array[@current_row + 1][-(@current_edge_len + 2)]
    when :down
      sum = [@spiral_array[@current_row][0]]
      sum << @spiral_array[@current_row + 1][0] if @current_row + 1 < @spiral_array.length
      sum <<  @spiral_array[@current_row - 1][0] << @spiral_array[@current_row - 1][1] if @current_row > 0
    end
    sum = sum.compact.inject(0) { |acc, i| acc += i }
    p sum if sum > 265149
    return sum
  end

  def add_nb
    case @state.current
    when :right
      @spiral_array[@current_row].push adj_sum
    when :up
      if @current_row - 1 < 0
        @spiral_array.unshift []
      else
        @current_row -= 1
      end
      @spiral_array[@current_row].push adj_sum
    when :left
      @spiral_array[@current_row].unshift adj_sum
    when :down
      @current_row += 1
      @spiral_array.push [] if @current_row >= @spiral_array.length
      @spiral_array[@current_row].unshift adj_sum
    end
    change_state
  end
end

SpiralArray.new(60)
