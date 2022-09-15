class DiagramWanderer
  PATH_TYPE = {
    up: '|',
    down: '|',
    left: '-',
    right: '-'
  }

  OPPOSITE_DIRECTION = {
    up: :down,
    down: :up,
    left: :right,
    right: :left
  }

  def initialize(file)
    @diagram = File.read(file).split "\n"
    @x = @diagram[0].index '|'
    @y = 0
    @going = :down
    @letters = []
    @step_nb = 1
  end

  def wander!
    until @going.nil?
      step!
      walk!
      @going = so_what_now?
    end
    self
  end

  def walk!
    until @diagram[@y][@x] == '+' || @diagram[@y][@x] == ' '
      @letters << @diagram[@y][@x] if @diagram[@y][@x].match? /[A-Z]/
      step!
    end
    self
  end

  def step!
    case @going
    when :down
      @y += 1
    when :left
      @x -= 1
    when :up
      @y -= 1
    when :right
      @x += 1
    end
    @step_nb += 1
    self
  end

  def so_what_now?
    surrounding = {
      up: @diagram[@y - 1][@x],
      down: @diagram[@y + 1][@x],
      right: @diagram[@y][@x + 1],
      left: @diagram[@y][@x - 1]
    }
    surrounding.delete_if { |k, v| v == ' ' || k == @going || k == OPPOSITE_DIRECTION[@going] || PATH_TYPE[k] != v }
    surrounding.keys.first
  end

  def path
    @letters.join
  end

  def final_step_nb
    @step_nb - 1
  end
end

p DiagramWanderer.new('input.txt').wander!.final_step_nb
