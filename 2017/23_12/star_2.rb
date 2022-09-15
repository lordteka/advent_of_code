class Coprocessor
  def initialize(instructions_list)
    @registers = [('a'..'h').to_a, [1] + [0] * 7].transpose.to_h
    @instructions_list = instructions_list
    @instructions = {
      "set" => ->(args) { set args[1], args[2] },
      "sub" => ->(args) { sub args[1], args[2] },
      "mul" => ->(args) { mul args[1], args[2] },
      "jnz" => ->(args) { jump_not_zero args[1], args[2] },
    }
  end

  def h
    @registers['h']
  end

  def perform!
    i = 0
    len = @instructions_list.length
    while i >= 0 && i < len
      i += @instructions[@instructions_list[i][0]].call @instructions_list[i]
    end
    self
  end

  def set(r, v)
    puts "set #{r} to #{v}(#{register_value(v)})"
    register_value!(r, register_value(v))
    1
  end

  def sub(r, v)
    puts "#{r} (#{register_value(v)}) minus #{v}(#{register_value(v)})"
    @registers[r] -= register_value v
    1
  end

  def mul(r, v)
    puts "#{r} (#{register_value(v)}) times #{v}(#{register_value(v)})"
    @registers[r] *= register_value v
    1
  end

  def jump_not_zero(v, offset)
    puts "jump if #{v}(#{register_value(v)}) != 0"
    return register_value(offset) unless register_value(v) == 0
    1
  end

  def register_value(r)
    return r if r.is_a? Integer
    @registers[r]
  end

  def register_value!(r, v)
    @registers[r] = v
  end
end

instructions_list = File.read('tronc_input.txt').split("\n").map { |line| line.split.map { |s| s.match?(/[0-9]+/) ? s.to_i : s } }
p Coprocessor.new(instructions_list).perform!.h
