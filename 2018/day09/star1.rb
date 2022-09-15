$index = 0
$circle = [0]

class Player
  attr_accessor :score

  def initialize
    @score = 0
  end

  def add_marble(marble)
    $index = ($index + 2) % $circle.length
    $circle.insert $index, marble
  end

  def keep_marble(marble)
    @score += marble
    $index -= 7
    $index += $circle.length if $index < 0
    @score += $circle.delete_at $index
    $index = 0 if $index == $circle.length
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

nb_player = 435
max_marble = 71184
p game(nb_player, max_marble)
