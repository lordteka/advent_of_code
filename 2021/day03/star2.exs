defmodule Main do
  import Bitwise

  def solve do
    report = IO.binstream() |> parse()

    binary_number_size = 12

    oxygen_generator_rating(report, binary_number_size) *
      co2_scrubber_rating(report, binary_number_size)
  end

  defp parse(stream) do
    stream
    |> Enum.map(fn line ->
      line
      |> String.trim_trailing()
      |> String.to_integer(2)
    end)
  end

  defp oxygen_generator_rating([rating], _offset), do: rating
  defp oxygen_generator_rating(_, 0), do: :error

  defp oxygen_generator_rating(report, offset) do
    most_used_bit = report |> bit_count(offset) |> most_used_bit

    report
    |> Enum.filter(&correct_bit?(&1, offset, most_used_bit))
    |> oxygen_generator_rating(offset - 1)
  end

  defp co2_scrubber_rating([rating], _offset), do: rating
  defp co2_scrubber_rating(_, 0), do: :error

  defp co2_scrubber_rating(report, offset) do
    least_used_bit = report |> bit_count(offset) |> least_used_bit

    report
    |> Enum.filter(&correct_bit?(&1, offset, least_used_bit))
    |> co2_scrubber_rating(offset - 1)
  end

  defp correct_bit?(num, offset, correct_bit) do
    mask = 0b1 <<< (offset - 1)

    num
    |> band(mask)
    |> bsr(offset - 1)
    |> bxor(correct_bit)
    |> Kernel.!=(0b1)
  end

  defp most_used_bit(%{1 => ones, 0 => zeros}) when ones >= zeros, do: 1
  defp most_used_bit(%{1 => _ones, 0 => _zeros}), do: 0
  defp least_used_bit(%{1 => ones, 0 => zeros}) when zeros <= ones, do: 0
  defp least_used_bit(%{1 => _ones, 0 => _zeros}), do: 1

  defp bit_count(report, offset) do
    Enum.frequencies_by(report, &(&1 |> band(0b1 <<< (offset - 1)) |> bsr(offset - 1)))
  end
end

Main.solve()
|> IO.inspect()
