defmodule Main do
  def solve do
    IO.binstream()
    |> parse()
    |> sum_output_nb()
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
    |> Enum.map(fn values ->
      String.split(values, " ")
      |> Enum.map(&String.to_charlist/1)
      |> Enum.map(&Enum.sort/1)
    end)
  end

  # len | numbers
  #  2  |  1
  #  3  |  7
  #  4  |  4
  #  5  |  2, 3, 5
  #  6  |  0, 6, 9
  #  7  |  8
  #   0:      1:      2:      3:      4:
  #  aaaa    ....    aaaa    aaaa    ....
  # b    c  .    c  .    c  .    c  b    c
  # b    c  .    c  .    c  .    c  b    c
  #  ....    ....    dddd    dddd    dddd
  # e    f  .    f  e    .  .    f  .    f
  # e    f  .    f  e    .  .    f  .    f
  #  gggg    ....    gggg    gggg    ....
  #
  #   5:      6:      7:      8:      9:
  #  aaaa    aaaa    aaaa    aaaa    aaaa
  # b    .  b    .  .    c  b    c  b    c
  # b    .  b    .  .    c  b    c  b    c
  #  dddd    dddd    ....    dddd    dddd
  # .    f  e    f  .    f  e    f  .    f
  # .    f  e    f  .    f  e    f  .    f
  #  gggg    gggg    ....    gggg    gggg

  defp build_key([input, _]) do
    [one, seven, four | tail] = Enum.sort(input, &(length(&1) <= length(&2)))
    five_letters_nb = Enum.filter(tail, &(length(&1) == 5))
    six_letters_nb = Enum.filter(tail, &(length(&1) == 6))
    eight = List.last(tail)

    a = get_a(one, seven)
    {nine, g} = get_nine_and_g(six_letters_nb, four, a)
    e = get_e(eight, nine)
    {three, d} = get_three_and_d(five_letters_nb, seven, g)
    b = get_b(three, nine)
    {two, f} = get_two_and_f(five_letters_nb, one, e)
    c = get_c(one, f)

    %{
      Enum.sort(a ++ b ++ c ++ e ++ f ++ g) => 0,
      Enum.sort(one) => 1,
      Enum.sort(two) => 2,
      Enum.sort(three) => 3,
      Enum.sort(four) => 4,
      Enum.sort(a ++ b ++ d ++ f ++ g) => 5,
      Enum.sort(a ++ b ++ d ++ e ++ f ++ g) => 6,
      Enum.sort(seven) => 7,
      Enum.sort(eight) => 8,
      Enum.sort(nine) => 9
    }
  end

  defp get_a(one, seven), do: seven -- one

  defp get_nine_and_g(six_letters_nb, four, a) do
    six_letters_nb
    |> Enum.map(&{&1, (&1 -- four) -- a})
    |> Enum.min_by(fn {_, left} -> length(left) end)
  end

  defp get_e(eight, nine), do: eight -- nine

  defp get_three_and_d(five_letters_nb, seven, g) do
    five_letters_nb
    |> Enum.map(&{&1, (&1 -- seven) -- g})
    |> Enum.min_by(fn {_, left} -> length(left) end)
  end

  defp get_b(three, nine), do: nine -- three

  defp get_two_and_f(five_letters_nb, one, e) do
    five_letters_nb
    |> Enum.map(&{&1, e -- &1})
    |> Enum.min_by(fn {_, left} -> length(left) end)
    |> then(fn {two, _} -> {two, one -- two} end)
  end

  defp get_c(one, f), do: one -- f

  defp sum_output_nb(list) do
    Enum.reduce(list, 0, fn line, acc ->
      key = build_key(line)

      line
      |> output_nb(key)
      |> Kernel.+(acc)
    end)
  end

  defp output_nb([_, output], key) do
    Enum.reduce(output, 0, fn value, acc ->
      acc * 10 + key[value]
    end)
  end
end

Main.solve()
|> IO.inspect()
