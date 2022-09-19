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

  defp fuel_consumption_to(pos_list, target) do
    pos_list
    |> Enum.reduce(0, fn pos, acc ->
      (pos - target)
      |> abs()
      |> sum_of_integers()
      |> Kernel.+(acc)
    end)
  end

  def sum_of_integers(n), do: div(n * (n + 1), 2)
end

Main.solve()
|> IO.inspect()
