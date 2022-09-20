defmodule Main do
  def solve do
    IO.binread(:stdio, :eof)
    |> parse()
    |> find_low_points()
    |> calculate_risk_level()
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

  defp calculate_risk_level(low_points) do
    Enum.reduce(low_points, 0, &(1 + &1 + &2))
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
      find_low_points(area, x + 1, y, [at(area, x, y) | acc])
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
