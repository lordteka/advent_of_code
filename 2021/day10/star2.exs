defmodule Stack do
  def update(['(' | tail], ')'),
    do: tail

  def update([_char | _tail], ')'),
    do: {:error, ')'}

  def update(stack, '('),
    do: ['(' | stack]

  def update(['[' | tail], ']'),
    do: tail

  def update([_char | _tail], ']'),
    do: {:error, ']'}

  def update(stack, '['),
    do: ['[' | stack]

  def update(['{' | tail], '}'),
    do: tail

  def update([_char | _tail], '}'),
    do: {:error, '}'}

  def update(stack, '{'),
    do: ['{' | stack]

  def update(['<' | tail], '>'),
    do: tail

  def update([_char | _tail], '>'),
    do: {:error, '>'}

  def update(stack, '<'),
    do: ['<' | stack]
end

defmodule Score do
  defp score('('), do: 1
  defp score('['), do: 2
  defp score('{'), do: 3
  defp score('<'), do: 4

  def compute([]), do: 0

  def compute(stack) do
    Enum.reduce(stack, 0, fn char, acc ->
      acc * 5 + score(char)
    end)
  end
end

defmodule Main do
  def solve do
    score_list = IO.binstream() |> missing_scores()
    mid = score_list |> length() |> div(2)

    score_list
    |> Enum.sort()
    |> List.to_tuple()
    |> elem(mid)
  end

  defp missing_scores(stream) do
    stream
    |> Enum.map(fn line ->
      line
      |> parse()
      |> find_missing()
      |> Score.compute()
    end)
    |> Enum.filter(&(&1 != 0))
  end

  defp parse(line) do
    line
    |> String.trim()
    |> String.to_charlist()
  end

  defp find_missing(line) do
    Enum.reduce_while(line, [], fn char, stack ->
      case Stack.update(stack, [char]) do
        {:error, _} -> {:halt, []}
        stack -> {:cont, stack}
      end
    end)
  end
end

Main.solve()
|> IO.inspect()
