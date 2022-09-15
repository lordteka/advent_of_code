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
    @spiral_array = [[]]
    @edge_size = 2
    @state = State.new
    @current_row = 0
    @change_state = 0
    @current_edge_len = 0

    (1..size).each do |nb|
      add_nb(nb)
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

  def add_nb(nb)
    case @state.current
    when :right
      @spiral_array[@current_row].push nb
    when :up
      if @current_row - 1 < 0
        @spiral_array.unshift []
      else
        @current_row -= 1
      end
      @spiral_array[@current_row].push nb
    when :left
      @spiral_array[@current_row].unshift nb
    when :down
      @current_row += 1
      @spiral_array.push [] if @current_row >= @spiral_array.length
      @spiral_array[@current_row].unshift nb
    end
    change_state
  end

  def manhattan_distance(goal)
    index_1 = []
    index_goal = []
    @spiral_array.each_with_index do |row, y|
      index_1 = [row.index(1), y] if row.index 1
      index_goal = [row.index(goal), y] if row.index goal
    end
    (index_1[0] - index_goal[0]).abs + (index_1[1] - index_goal[1]).abs
  end
end

p SpiralArray.new(265149).manhattan_distance(265149)
