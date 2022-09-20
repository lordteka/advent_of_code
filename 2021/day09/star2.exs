defmodule Main do
  def solve do
    area = IO.binread(:stdio, :eof) |> parse()
    points = find_low_points(area)

    calculate_bassin_sizes(area, points)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.product()
  end

  defp parse(lines) do
    lines
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split("", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
    |> List.to_tuple()
  end

  defp explore_bassin(_area, x, y, already_visited) when x < 0 or y < 0,
    do: already_visited

  defp explore_bassin(area, _x, y, already_visited) when y >= tuple_size(area),
    do: already_visited

  defp explore_bassin(area, x, y, already_visited) when x >= tuple_size(elem(area, y)),
    do: already_visited

  defp explore_bassin(area, x, y, already_visited) when area |> elem(y) |> elem(x) == 9,
    do: already_visited

  defp explore_bassin(area, x, y, already_visited) do
    if {x, y} in already_visited do
      already_visited
    else
      next_destinations(x, y, already_visited)
      |> Enum.reduce([{x, y} | already_visited], fn {next_x, next_y}, already_visited ->
        explore_bassin(area, next_x, next_y, already_visited)
      end)
    end
  end

  defp next_destinations(x, y, already_visited),
    do: [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}] -- already_visited

  defp calculate_bassin_sizes(area, low_points) do
    Enum.map(low_points, fn {x, y} ->
      area
      |> explore_bassin(x, y, [])
      |> length()
    end)
  end

  defp find_low_points(area) do
    find_low_points(area, 0, 0, [])
  end

  defp find_low_points(area, _x, y, acc) when y >= tuple_size(area),
    do: acc

  defp find_low_points(area, x, y, acc) when x >= tuple_size(elem(area, y)),
    do: find_low_points(area, 0, y + 1, acc)

  defp find_low_points(area, x, y, acc) do
    if low_point?(area, x, y) do
      find_low_points(area, x + 1, y, [{x, y} | acc])
    else
      find_low_points(area, x + 1, y, acc)
    end
  end

  defp low_point?(area, x, y) when area |> elem(y) |> elem(x) == 9,
    do: false

  defp low_point?(area, x, y) do
    at(area, x, y) < at(area, x - 1, y) and
      at(area, x, y) < at(area, x, y - 1) and
      at(area, x, y) < at(area, x, y + 1) and
      at(area, x, y) < at(area, x + 1, y)
  end

  defp at(_area, x, y) when x < 0 or y < 0, do: 9
  defp at(area, _x, y) when y >= tuple_size(area), do: 9
  defp at(area, x, y) when x >= tuple_size(elem(area, y)), do: 9
  defp at(area, x, y), do: area |> elem(y) |> elem(x)
end

Main.solve()
|> IO.inspect()
