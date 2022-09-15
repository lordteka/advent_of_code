class Circle
  Elem = Struct.new :value, :prev, :next

  def initialize
    @current = Elem.new 0, nil, nil
    @current.prev = @current
    @current.next = @current
  end

  def add(value)
    forward 
    elem = Elem.new value, @current, @current.next
    @current.next.prev = elem
    @current.next = elem
    @current = elem
  end

  def remove
    backward 7
    @current.prev.next = @current.next
    @current.next.prev = @current.prev
    value = @current.value
    @current = @current.next
    value
  end

  private

  def forward(i = 1)
    i.times { @current = @current.next }
  end

  def backward(i = 1)
    i.times { @current = @current.prev }
  end
end

class Player
  attr_accessor :score

  def initialize
    @score = 0
  end

  def add_marble(marble)
    CIRCLE.add marble
  end

  def keep_marble(marble)
    @score += marble
    @score += CIRCLE.remove
  end

  def play(marble)
    marble % 23 == 0 ? keep_marble(marble) : add_marble(marble)
  end
end

def winner_score(players)
  players.max { |p1, p2| p1.score <=> p2.score }.score
end

def game(nb_player, max_marble)
  players = Array.new(nb_player) { Player.new }
  marbles = (1..max_marble).to_a   
  players.cycle do |player|
    break if marbles.empty?
    player.play marbles.shift
  end
  winner_score players
end

CIRCLE = Circle.new
nb_player = 435
max_marble = 7118400
p game(nb_player, max_marble)
