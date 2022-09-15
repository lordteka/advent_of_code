changes_list = File.readlines(file).map { |c| c.to_i }
frequency = 0
frequency_history = [0]
changes_list.cycle do |change|
  frequency += change
  break if frequency_history.include? frequency
  frequency_history << frequency
end

p frequency
