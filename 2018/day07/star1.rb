def build_graph(file)
  graph = {}
  File.readlines(file).each do |line|
    tmp = line.chomp.match(/.*? (?<prerequisite>[A-Z]) .*? (?<step>[A-Z]) .*?/)
    graph[tmp[:step]] ||= [] and graph[tmp[:step]] << tmp[:prerequisite]
  end
  graph.each { |k, v| v.sort! }
end

def find_first_steps(graph)
  (graph.values.flatten.uniq - graph.keys)
end

def order_step(graph)
  done = [] 
  todo = find_first_steps(graph).sort
  while todo.length > 0
    current_step = todo.shift
    graph.each do |step, prerequisites|
      prerequisites.reject! { |p| p == current_step }
      todo << step and prerequisites << "complete" if prerequisites.empty?
    end
    done << current_step
    todo.sort!
  end
  done.reduce(&:+)
end

g = build_graph('input')
p order_step g
