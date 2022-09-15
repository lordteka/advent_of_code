class Grid
  require './knot_hash'

  attr_reader :regions_nb

  def initialize(input)
    @regions_nb = 0
    @grid = (0..127).inject [] do |grid, i|
      kh = KnotHash.new((0..255).to_a, "#{input}-#{i}".chars.map { |c| c.ord } + [17, 31, 73, 47, 23])
      grid << kh.round!.sparse_to_dense!.bin_hash.chars
    end
  end

  def highlight_regions!
    @grid.each_with_index do |row, y|
      row.each_with_index do |_, x|
        if @grid[y][x] != '0' && @grid[y][x] == '1'
          propagate! x, y
          @regions_nb += 1
        end
      end
    end
    self
  end

  private

  def propagate!(x, y)
    return if @grid[y][x].to_i == @regions_nb || @grid[y][x] == '0'
    @grid[y][x] = @regions_nb
    propagate!(x - 1, y) if x > 0
    propagate!(x, y - 1) if y > 0
    propagate!(x + 1, y) if x < 127
    propagate!(x, y + 1) if y < 127
  end
end

g = Grid.new("vbqugkhl")
p g.highlight_regions!.regions_nb - 1
