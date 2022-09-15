def count_score(f, score=0, depth=1)
  inside_garbage = false
  f.slice! 0 if depth == 1

  until f.empty?
    case f[0]
    when '{'
      f.slice! 0
      score = count_score(f, score, depth + 1) unless inside_garbage
    when '}'
      f.slice! 0
      return score + depth unless inside_garbage
    when '<'
      inside_garbage = true
      f.slice! 0
    when '>'
      inside_garbage = false
      f.slice! 0
    when '!'
      f.slice! 0
      f.slice! 0
    else
      f.slice! 0
    end
  end
end

f = File.read 'input.txt'
p count_score(f)
