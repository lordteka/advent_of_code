class Generator
  class Handler
    attr_reader :similar_count

    def initialize(generatorA, generatorB)
      @generatorA = generatorA
      @generatorB = generatorB
      @similar_count = 0
    end

    def first_16_bits(value)
      first16 = value.to_s(2).rjust(32, '0')
      first16.slice! 0..15
      first16
    end

    def generate!(n)
      i = 0
      until i == n
        a = @generatorA.next_value!.values[i]
        b = @generatorB.next_value!.values[i]
        if a != nil && b != nil
          @similar_count += 1 if first_16_bits(a) == first_16_bits(b)
          i += 1
        end
      end
      self
    end
  end

  attr_reader :values

  def initialize(first_value, factor)
    @prev_value = first_value
    @factor = factor
    @values = []
  end

  def next_value!
    next_value = ((@prev_value * @factor) % 2147483647)
    @prev_value = next_value
    self
  end
end

class GeneratorA < Generator
  def initialize(first_value)
    super first_value, 16807
  end

  def next_value!
    super
    @values << @prev_value if @prev_value % 4 == 0
    self
  end
end

class GeneratorB < Generator
  def initialize(first_value)
    super first_value, 48271
  end

  def next_value!
    super
    @values << @prev_value if @prev_value % 8 == 0
    self
  end
end


a = GeneratorA.new 277
b = GeneratorB.new 349
h = Generator::Handler.new(a, b)

p h.generate!(5000000).similar_count
