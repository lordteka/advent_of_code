puts File.readlines('input').reduce(0) { |frequency, change| frequency += change.to_i }
