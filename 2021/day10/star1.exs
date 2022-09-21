defmodule Main do
  def solve do
    IO.binstream()
    |> error_score()
  end

  defp error_score(stream) do
    stream
    |> Enum.reduce(0, fn line, acc ->
      line
      |> parse()
      |> find_error()
      |> score()
      |> Kernel.+(acc)
    end)
  end

  defp parse(line) do
    line
    |> String.trim()
    |> String.to_charlist()
  end

  defp find_error(line) do
    Enum.reduce_while(line, [], fn char, stack ->
      case update_stack([char], stack) do
        {:error, char} -> {:halt, char}
        stack -> {:cont, stack}
      end
    end)
  end

  defp update_stack(')', ['(' | tail]),
    do: tail

  defp update_stack(')', [_char | _tail]),
    do: {:error, ')'}

  defp update_stack('(', stack),
    do: ['(' | stack]

  defp update_stack(']', ['[' | tail]),
    do: tail

  defp update_stack(']', [_char | _tail]),
    do: {:error, ']'}

  defp update_stack('[', stack),
    do: ['[' | stack]

  defp update_stack('}', ['{' | tail]),
    do: tail

  defp update_stack('}', [_char | _tail]),
    do: {:error, '}'}

  defp update_stack('{', stack),
    do: ['{' | stack]

  defp update_stack('>', ['<' | tail]),
    do: tail

  defp update_stack('>', [_char | _tail]),
    do: {:error, '>'}

  defp update_stack('<', stack),
    do: ['<' | stack]

  defp score(')'), do: 3
  defp score(']'), do: 57
  defp score('}'), do: 1197
  defp score('>'), do: 25137
  defp score(_char), do: 0
end

Main.solve()
|> IO.inspect()
