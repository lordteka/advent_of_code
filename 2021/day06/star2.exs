defmodule Main do
  def solve do
    IO.binread(:stdio, :eof)
    |> parse()
    |> run_for(256)
    |> count_fishes()
  end

  defp parse(line) do
    map =
      line
      |> String.trim()
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      |> Enum.frequencies()

    [
      Map.get(map, 0, 0),
      Map.get(map, 1, 0),
      Map.get(map, 2, 0),
      Map.get(map, 3, 0),
      Map.get(map, 4, 0),
      Map.get(map, 5, 0),
      Map.get(map, 6, 0),
      Map.get(map, 7, 0),
      Map.get(map, 8, 0)
    ]
  end

  defp run_for(fish_list, days) do
    Enum.reduce(1..days, fish_list, fn _, fish_list ->
      update_fish(fish_list)
    end)
  end

  defp update_fish([head | tail]) do
    List.update_at(tail, 6, &(&1 + head)) ++ [head]
  end

  defp count_fishes(fish_list), do: Enum.sum(fish_list)
end

Main.solve()
|> IO.inspect()
