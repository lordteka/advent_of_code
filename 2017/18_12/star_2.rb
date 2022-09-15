class Duet
  attr_writer :partner
  attr_reader :queue, :done, :send_count

  def initialize(instructions_list, nb, partner=nil)
    @registers = Hash.new nb
    @instructions_list = instructions_list
    @queue = []
    @partner = partner
    @instr_idx = 0
    @waiting = false
    @done = false
    @send_count = 0
    @instructions = {
      "snd" => ->(args) { send! args[1] },
      "set" => ->(args) { set! args[1], args[2] },
      "add" => ->(args) { add! args[1], args[2] },
      "mul" => ->(args) { mul! args[1], args[2] },
      "mod" => ->(args) { mod! args[1], args[2] },
      "rcv" => ->(args) { receive! args[1] },
      "jgz" => ->(args) { jump_greater_than_zero! args[1], args[2] },
    }
  end

  def perform!
    len = @instructions_list.length
    @waiting = false
    while @instr_idx >= 0 && @instr_idx < len && !@waiting
      @instructions[@instructions_list[@instr_idx][0]].call @instructions_list[@instr_idx]
    end
    @done = true unless @waiting
    self
  end

  def send!(x)
    @partner.queue << register_value(x)
    @send_count += 1
    @instr_idx += 1
  end

  def set!(r, v)
    register_value!(r, register_value(v))
    @instr_idx += 1
  end

  def add!(r, v)
    @registers[r] += register_value v
    @instr_idx += 1
  end

  def mul!(r, v)
    @registers[r] *= register_value v
    @instr_idx += 1
  end

  def mod!(r, v)
    @registers[r] = @registers[r] % register_value(v)
    @instr_idx += 1
  end

  def receive!(x)
    if @queue.empty?
      @waiting = true
    else
      register_value! x, @queue.shift
      @instr_idx += 1
    end
  end

  def jump_greater_than_zero!(v, offset)
    if register_value(v) > 0
      @instr_idx += register_value(offset)
    else
      @instr_idx += 1
    end
  end

  def register_value(r)
    return r.to_i if r.match? /[0-9]+/

    @registers[r]
  end

  def register_value!(r, v)
    @registers[r] = v
  end

  def lock?
    @waiting && @queue.empty?
  end
end

instructions_list = File.read('input.txt').split("\n").map { |line| line.split }
p0 = Duet.new(instructions_list, 0)
p1 = Duet.new(instructions_list, 1, p0)
p0.partner = p1

until (p0.done && p1.done) || (p0.lock? && p1.lock?) || (p0.done && p1.lock?) || (p0.lock? && p1.done)
  p0.perform!
  p1.perform!
end
p p1.send_count
