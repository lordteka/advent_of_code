class Coprocessor
  attr_reader :mul_count

  def initialize(instructions_list)
    @registers = Hash.new 0
    @instructions_list = instructions_list
    @mul_count = 0
    @instructions = {
      "set" => ->(args) { set args[1], args[2] },
      "sub" => ->(args) { sub args[1], args[2] },
      "mul" => ->(args) { mul args[1], args[2] },
      "jnz" => ->(args) { jump_not_zero args[1], args[2] },
    }
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
    register_value!(r, register_value(v))
    1
  end

  def sub(r, v)
    @registers[r] -= register_value v
    1
  end

  def mul(r, v)
    @registers[r] *= register_value v
    @mul_count += 1
    1
  end

  def jump_not_zero(v, offset)
    return register_value(offset) unless register_value(v) == 0
    1
  end

  def register_value(r)
    return r.to_i if r.match? /[0-9]+/

    @registers[r]
  end

  def register_value!(r, v)
    @registers[r] = v
  end
end

instructions_list = File.read('input.txt').split("\n").map { |line| line.split }
p Coprocessor.new(instructions_list).perform!.mul_count
