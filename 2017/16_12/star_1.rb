LAYOUT = ('a'..'p').to_a

def spin(i)
  i.times do
    LAYOUT.unshift LAYOUT.pop
  end
end

def exchange(a, b)
  tmp = LAYOUT[a]
  LAYOUT[a] = LAYOUT[b]
  LAYOUT[b] = tmp
end

def partner(a, b)
  exchange LAYOUT.index(a), LAYOUT.index(b)
end

FONCTIONS = {
  "s" => ->(arg_tab) { spin arg_tab[0] },
  "x" => ->(arg_tab) { exchange arg_tab[0], arg_tab[1] },
  "p" => ->(arg_tab) { partner arg_tab[0], arg_tab[1] }
}

f = File.read('input.txt').strip.split(',')

f.each do |cmd|
  name = cmd.slice! 0
  arg = cmd.split('/').map { |i| i.match?(/[0-9]+/) ? i.to_i : i }
  FONCTIONS[name].call(arg)
end

p LAYOUT.join
