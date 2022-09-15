class Dance
  def initialize(cmd_list)
    @raw_cmds = cmd_list
    @layout = ('a'..'p').to_a
    @commands = []
    @memory = [('a'..'p').to_a.join]
    @current_layout = 0
    @fonctions = {
      "s" => ->(arg_tab) { spin! arg_tab[0] },
      "x" => ->(arg_tab) { exchange! arg_tab[0], arg_tab[1] },
      "p" => ->(arg_tab) { partner! arg_tab[0], arg_tab[1] }
    }
  end

  def perform!(n)
    first_dance!.find_loop! (n - 1)
    @current_layout = n % @memory.length
    self
  end

  def layout
    @memory[@current_layout]
  end

  def first_dance!
    @raw_cmds.each do |cmd|
      name = cmd.slice! 0
      arg = cmd.split('/').map { |i| i.match?(/[0-9]+/) ? i.to_i : i }
      @commands << [@fonctions[name], arg]
      @fonctions[name].call(arg)
    end
    @memory << @layout.join
    @current_layout += 1
    self
  end

  def find_loop!(n)
    n.times do
      @commands.each { |cmd| cmd[0].call cmd[1] }
      s_layout = @layout.join
      if @memory.include? s_layout
        return self
      else
        @memory << s_layout
      end
      @current_layout += 1
    end
    self
  end

  def spin!(n)
    n.times do
      @layout.unshift @layout.pop
    end
    self
  end

  def exchange!(a, b)
    tmp = @layout[a]
    @layout[a] = @layout[b]
    @layout[b] = tmp
    self
  end

  def partner!(a, b)
    exchange! @layout.index(a), @layout.index(b)
    self
  end
end

cmd_list = File.read('input.txt').strip.split(',')

p Dance.new(cmd_list).perform!(1000000000).layout
