class Manager
  attr_reader :clock

  def initialize(instructions)
    @workers = Array.new(5) { Worker.new self }
    @clock = 0
    @instructions = instructions
    @todo = find_first_steps instructions
    @first_steps_number = @todo.length
    @done = []
  end

  def follow_instructions
    until @todo.empty? && @workers.all? { |w| !w.working? }
      dispatch
      while @todo.empty? || @workers.all?(&:working?)
        @workers.each { |w| w.work }
        tick
        return self if done?
      end
    end
  end

  def cross_out(task)
    #puts("task #{task} done")
    @done << task
    @instructions.each do |step, prerequisites|
      prerequisites.reject! { |p| p == task }
      @todo << step and prerequisites << 'complete' if prerequisites.empty?
    end
    @todo.sort! 
  end

  private

  def dispatch
    until @todo.empty? || @workers.all?(&:working?) 
      #puts "to do: #{@todo}"
      task = @todo.first
      assigned = false 
      @workers.each { |w| w.assign task and assigned = true and break unless w.working? }
      @todo.shift if assigned
    end
  end

  def done?
    @done.length == @instructions.keys.length + @first_steps_number
  end

  def tick
    @clock += 1
  end

  def find_first_steps(graph)
    (graph.values.flatten.uniq - graph.keys).sort
  end
end

class Worker
  def initialize(manager)
    @task = nil
    @remaining_work = 0
    @manager = manager
  end

  def assign(task)
    @task = task
    @remaining_work = task_time
  end

  def work
    @remaining_work -= 1
    @manager.cross_out @task if @remaining_work == 0
  end

  def working?
    @remaining_work > 0
  end

  private

  def task_time
    60 + @task.ord - 'A'.ord + 1
  end
end

def build_graph(file)
  graph = {}
  File.readlines(file).each do |line|
    tmp = line.chomp.match(/.*? (?<prerequisite>[A-Z]) .*? (?<step>[A-Z]) .*?/)
    graph[tmp[:step]] ||= [] and graph[tmp[:step]] << tmp[:prerequisite]
  end
  graph.each { |k, v| v.sort! }
end



g = build_graph('input')
p Manager.new(g).follow_instructions.clock
