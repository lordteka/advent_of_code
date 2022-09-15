defmodule Main do
  import Bitwise

  def solve do
    IO.binstream()
    |> parse()
    |> get_gamma_rate()
    |> get_power_consumption()
  end

  defp parse(stream) do
    stream
    |> Enum.map(fn line ->
      line
      |> String.trim_trailing()
      |> String.split("", trim: true)
    end)
  end

  defp get_power_consumption(gamma_rate), do: gamma_rate * epsilon_rate(gamma_rate)

  defp epsilon_rate(gamma_rate),
    do: gamma_rate |> bnot |> band(0b111111111111)

  defp get_gamma_rate(report) do
    half = report |> length |> div(2)

    report
    |> Enum.reduce(&add_digits(&1, &2))
    |> Enum.map(&most_used_bit(&1, half))
    |> Integer.undigits(2)
  end

  defp add_digits(b1, b2), do: Enum.zip_with(b1, b2, &add_bits(&1, &2))

  defp add_bits("1", "1"), do: 2
  defp add_bits("0", "0"), do: 0
  defp add_bits("1", "0"), do: 1
  defp add_bits("0", "1"), do: 1
  defp add_bits("0", x), do: x
  defp add_bits("1", x), do: x + 1

  defp most_used_bit(sum, half) when sum > half, do: 1
  defp most_used_bit(_sum, _half), do: 0
end

Main.solve()
|> IO.inspect()
