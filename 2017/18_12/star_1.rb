class Duet

  def initialize(instructions_list)
    @registers = Hash.new 0
    @instructions_list = instructions_list
    @last_sound = 0
    @instructions = {
      "snd" => ->(args) { sound args[1] },
      "set" => ->(args) { set args[1], args[2] },
      "add" => ->(args) { add args[1], args[2] },
      "mul" => ->(args) { mul args[1], args[2] },
      "mod" => ->(args) { mod args[1], args[2] },
      "rcv" => ->(args) { recover args[1] },
      "jgz" => ->(args) { jump_greater_than_zero args[1], args[2] },
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

  def sound(x)
    @last_sound = register_value(x)
    1
  end

  def set(r, v)
    register_value!(r, register_value(v))
    1
  end

  def add(r, v)
    @registers[r] += register_value v
    1
  end

  def mul(r, v)
    @registers[r] *= register_value v
    1
  end

  def mod(r, v)
    @registers[r] = @registers[r] % register_value(v)
    1
  end

  def recover(x)
    if register_value(x) != 0
      puts @last_sound
      exit
    end
    1
  end

  def jump_greater_than_zero(v, offset)
    return register_value(offset) if register_value(v) > 0
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
Duet.new(instructions_list).perform!
