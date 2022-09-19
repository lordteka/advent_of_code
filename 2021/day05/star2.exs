defmodule Main do
  def solve do
    IO.binstream()
    |> parse()
    |> compute_lines()
    |> count_overlap()
  end

  defp parse(stream) do
    stream
    |> Enum.reduce([], fn line, acc ->
      [line |> apply_regex() |> line_to_coord() | acc]
    end)
  end

  defp apply_regex(line) do
    ~r/(\d+),(\d+) -> (\d+),(\d+)/
    |> Regex.run(line, capture: :all_but_first)
  end

  defp line_to_coord([x1, y1, x2, y2]), do:
    [
      {String.to_integer(x1), String.to_integer(y1)},
      {String.to_integer(x2), String.to_integer(y2)}
    ]

  defp compute_lines(pos) do
    pos
    |> Enum.reduce(%{}, fn [p1, p2], map ->
      Map.merge(
        map,
        compute_line(p1, p2),
        fn _k, v1, v2 -> v1 + v2 end
      )
    end)
  end

  # horizontal
  defp compute_line({x, y1}, {x, y2}) do
    y1..y2
    |> Enum.reduce(%{}, fn y, acc ->
      Map.put(acc, {x, y}, 1)
    end)
  end

  # vertical
  defp compute_line({x1, y}, {x2, y}) do
    x1..x2
    |> Enum.reduce(%{}, fn x, acc ->
      Map.put(acc, {x, y}, 1)
    end)
  end

  # diagonal
  defp compute_line({x1, y1}, {x2, y2}) do
    Enum.zip_reduce(x1..x2, y1..y2, %{}, fn x, y, acc ->
      Map.put(acc, {x, y}, 1)
    end)
  end

  defp count_overlap(point_map) do
    Enum.count(point_map, fn {_k, v} -> v >= 2 end)
  end
end

Main.solve()
|> IO.inspect()
