defmodule Main do
  def solve do
    {sequence, rules} = IO.binread(:stdio, :eof) |> parse()

    {min, max} =
      get_frequencies_for_depth(sequence, rules, 10)
      |> Enum.map(fn {_k, v} -> v end)
      |> Enum.min_max()

    max - min
  end

  defp parse(file) do
    [sequence, rules] = String.split(file, "\n\n", trim: true)

    rules =
      String.split(rules, "\n", trim: true)
      |> Enum.reduce(%{}, fn rule, rules ->
        [k, v] = Regex.run(~r/(\w+) -> (\w)/, rule, capture: :all_but_first)

        Map.put(rules, String.to_charlist(k), String.to_charlist(v))
      end)

    {String.to_charlist(sequence), rules}
  end

  defp get_frequencies_for_depth(sequence, rules, depth) do
    sequence_frequencies =
      sequence
      |> Enum.map(&[&1])
      |> Enum.frequencies()

    get_frequencies(sequence, rules, [], depth)
    |> Enum.reduce(
      sequence_frequencies,
      &merge_frequencies(&2, &1)
    )
  end

  defp get_frequencies(sequence, rules, frequencies, depth) do
    case get_next_duo(sequence) do
      {duo, :none} ->
        polymorph(frequencies, duo, rules, depth)

      {duo, sequence} ->
        get_frequencies(
          sequence,
          rules,
          polymorph(frequencies, duo, rules, depth),
          depth
        )
    end
  end

  defp get_next_duo([l, r | []]), do: {[l, r], :none}
  defp get_next_duo([l, r | t]), do: {[l, r], [r | t]}

  defp polymorph(frequencies, _duo, _rules, 0), do: frequencies

  defp polymorph(frequencies, [l, r] = duo, rules, depth) do
    mid = rules[duo]

    [%{mid => 1} | frequencies]
    |> polymorph([l] ++ mid, rules, depth - 1)
    |> polymorph(mid ++ [r], rules, depth - 1)
  end

  defp merge_frequencies(m1, m2) do
    Map.merge(m1, m2, fn _k, v1, v2 -> v1 + v2 end)
  end
end

Main.solve()
|> IO.inspect()
