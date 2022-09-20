defmodule Main do
  def solve do
    IO.binstream()
    |> parse()
    |> count_special_nb()
  end

  defp parse(stream) do
    stream
    |> Enum.reduce([], fn line, acc ->
      [parse_line(line) | acc]
    end)
  end

  defp parse_line(line) do
    String.trim(line)
    |> String.split(" | ")
    |> Enum.map(&String.split(&1, " "))
  end

  defp count_special_nb(list) do
    Enum.reduce(list, 0, fn line, acc ->
      line
      |> count_special_nb_line()
      |> Kernel.+(acc)
    end)
  end

  defp count_special_nb_line([_, output]) do
    Enum.count(output, fn value ->
      case String.length(value) do
        2 -> true
        3 -> true
        4 -> true
        7 -> true
        _ -> false
      end
    end)
  end
end

Main.solve()
|> IO.inspect()
