class Virus
  STATE = {
    '#' => :infected,
    '.' => :clean
  }

  STATE_CHAR = {
    infected: '#',
    clean: '.'
  }

  ORIENTATION = {
    up: {
      left: :left,
      right: :right
    },
    right: {
      left: :up,
      right: :down
    },
    down: {
      left: :right,
      right: :left
    },
    left: {
      left: :down,
      right: :up
    }
  }

  attr_reader :infection_count

  def initialize(file)
    @grid = File.read(file).split "\n"
    @x = @grid[0].length / 2
    @y = @grid.length / 2
    @heading = :up
    @infection_count = 0
  end

  def burst_n_times!(n)
    n.times do
      burst!
    end
    self
  end

  def burst!
    orienting!
    infecting!
    moving!
    self
  end

  def orienting!
    @heading = ORIENTATION[@heading][STATE[@grid[@y][@x]] == :infected ? :right : :left]
    self
  end

  def infecting!
    @grid[@y][@x] = STATE[@grid[@y][@x]] == :clean ? STATE_CHAR[:infected] : STATE_CHAR[:clean]
    @infection_count += 1 if STATE[@grid[@y][@x]] == :infected
    self
  end

  def moving!
    case @heading
    when :up
      @y -= 1
    when :right
      @x += 1
    when :down
      @y += 1
    when :left
      @x -= 1
    end
    expand_grid! if @x >= @grid[0].length || @x < 0 || @y >= @grid.length || @y < 0
    self
  end

  private

  def expand_grid!
    case @heading
    when :up
      @grid.unshift('.' * @grid[0].length)
      @y += 1
    when :right
      @grid.map! { |line| line + '.'}
    when :down
      @grid << '.' * @grid[0].length
    when :left
      @grid.map! { |line| '.' + line }
      @x += 1
    end
    self
  end
end

p Virus.new('input.txt').burst_n_times!(10000).infection_count
