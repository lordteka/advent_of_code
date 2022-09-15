class Generator
  class Handler
    attr_reader :similar_count

    def initialize(generatorA, generatorB)
      @generatorA = generatorA
      @generatorB = generatorB
      @similar_count = 0
    end

    def generate!(n)
      n.times do
        @similar_count += 1 if @generatorA.next_value!.first16 == @generatorB.next_value!.first16
      end
      self
    end
  end

  attr_reader :first16

  def initialize(first_value, factor)
    @prev_value = first_value
    @factor = factor
    @first16 = ""
  end

  def next_value!
    next_value = ((@prev_value * @factor) % 2147483647)
    @prev_value = next_value
    next_value = next_value.to_s(2).rjust(32, '0')
    next_value.slice!(0..15)
    @first16 = next_value
    self
  end
end

class GeneratorA < Generator
  def initialize(first_value)
    super first_value, 16807
  end
end

class GeneratorB < Generator
  def initialize(first_value)
    super first_value, 48271
  end
end


a = GeneratorA.new 277
b = GeneratorB.new 349
h = Generator::Handler.new(a, b)

p h.generate!(40000000).similar_count
