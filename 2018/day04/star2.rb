class Guard
  attr_reader :id

  def initialize(id)
    @id = id.to_i
    @nights = {}
  end

  def add_nap(falls_asleep, wakes_up)
    date = "#{falls_asleep.year}-#{falls_asleep.month}-#{falls_asleep.day}"
    nap_duration = (falls_asleep.min...wakes_up.min)
    @nights[date] ||= Array.new 60, 0
    @nights[date].each_with_index { |_, index| @nights[date][index] = 1 if nap_duration.include? index }
  end

  def minute_most_slept
    @nights.values.transpose.map { |a| a.sum }.each_with_index.max
  end
end

class LogLine
  attr_reader :id, :time, :action

  def initialize(line)
    id_regexp = /#(?<guard_id>\d+)/
    date_regexp = /\[(?<year>\d+)-(?<month>\d+)-(?<day>\d+) (?<hour>\d+):(?<minutes>\d+)\]/
    action_regexp = /(?<action>\w+\s\w+)$/
    date = date_regexp.match line
    @id = id_regexp.match(line)&.send '[]', :guard_id
    @time = Time.new(date[:year], date[:month], date[:day], date[:hour], date[:minutes])
    @action = action_regexp.match(line)[:action].sub(/ /, '_').to_sym
  end
end

def create_guard_list(file)
  l = File.readlines(file).map { |line| LogLine.new line }
  l.sort! { |l1, l2| l1.time <=> l2.time }
  guard_list = {}
  nap_start = nil
  current_guard = nil
  l.each do |line|
    case(line.action)
    when :begins_shift
      guard_list[line.id] ||= Guard.new line.id
      current_guard = guard_list[line.id]
    when :falls_asleep
      nap_start = line.time
    when :wakes_up
      current_guard.add_nap nap_start, line.time
    end
  end
  guard_list
end

gl = create_guard_list('input')
sleepiest_guard = gl.values.max_by { |guard| guard.minute_most_slept&.first || 0 }
p sleepiest_guard.id * sleepiest_guard.minute_most_slept.last
