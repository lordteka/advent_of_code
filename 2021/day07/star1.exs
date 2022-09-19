defmodule Main do
  def solve do
    IO.binread(:stdio, :eof)
    |> parse()
    |> compute_fuel_for_all()
    |> Enum.min()
  end

  defp parse(line) do
    line
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  defp compute_fuel_for_all(pos_list) do
    limit = Enum.max(pos_list)

    Enum.map(0..limit, &fuel_consumption_to(pos_list, &1))
  end

  defp fuel_consumption_to(pos_list, pos) do
    pos_list
    |> Enum.reduce(0, &(&2 + abs(&1 - pos)))
  end
end

Main.solve()
|> IO.inspect()
