def count_chars(f)
  inside_garbage = false
  chars = 0
  f.slice! -1

  until f.empty?
    case f[0]
    when '{'
      chars += 1 if inside_garbage
      f.slice! 0
    when '}'
      chars += 1 if inside_garbage
      f.slice! 0
    when '<'
      chars += 1 if inside_garbage
      inside_garbage = true
      f.slice! 0
    when '>'
      inside_garbage = false
      f.slice! 0
    when '!'
      f.slice! 0
      f.slice! 0
    else
      chars += 1 if inside_garbage
      f.slice! 0
    end
  end
  chars
end

f = File.read 'input.txt'
p count_chars(f)
