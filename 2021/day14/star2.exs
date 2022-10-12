defmodule Main do
  def solve do
    {sequence, rules} = IO.binread(:stdio, :eof) |> parse()

    {min, max} =
      get_frequencies_for_depth(sequence, rules, 40)
      |> IO.inspect()
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
      |> Enum.into(%{}, fn {[l, r] = k, v} -> {k, {v, [l] ++ v, v ++ [r]}} end)

    {String.to_charlist(sequence), rules}
  end

  defp get_frequencies_for_depth(sequence, rules, depth) do
    sequence_frequencies =
      sequence
      |> Enum.map(&[&1])
      |> Enum.frequencies()

    get_frequencies(%{}, sequence, rules, init_memory(rules, depth), depth)
    |> merge_frequencies(sequence_frequencies)
  end

  defp init_memory(rules, depth) do
    Enum.into(rules, %{}, fn {duo, _} ->
      {
        duo,
        Tuple.duplicate(nil, depth + 1)
      }
    end)
  end

  defp get_frequencies(frequencies, sequence, rules, memory, depth) do
    case get_next_duo(sequence) do
      {duo, :none} ->
        {f, _memory} = polymorph(memory, duo, rules, depth)
        merge_frequencies(frequencies, f)

      {duo, sequence} ->
        {f, memory} = polymorph(memory, duo, rules, depth)

        frequencies
        |> merge_frequencies(f)
        |> get_frequencies(sequence, rules, memory, depth)
    end
  end

  defp get_next_duo([l, r | []]), do: {[l, r], :none}
  defp get_next_duo([l, r | t]), do: {[l, r], [r | t]}

  defp polymorph(memory, duo, rules, 1) do
    {letter, _l, _r} = rules[duo]

    {%{letter => 1}, memory}
  end

  defp polymorph(memory, duo, rules, depth) do
    case elem(memory[duo], depth) do
      nil -> explore(memory, duo, rules, depth)
      value -> {value, memory}
    end
  end

  defp explore(memory, duo, rules, depth) do
    {letter, left, right} = rules[duo]

    {left_frequencies, memory} = polymorph(memory, left, rules, depth - 1)
    {right_frequencies, memory} = polymorph(memory, right, rules, depth - 1)

    frequencies =
      left_frequencies
      |> merge_frequencies(right_frequencies)
      |> merge_frequencies(%{letter => 1})

    {
      frequencies,
      %{memory | duo => put_elem(memory[duo], depth, frequencies)}
    }
  end

  defp merge_frequencies(m1, m2) when is_map(m1) and is_map(m2) do
    Map.merge(m1, m2, fn _k, v1, v2 -> v1 + v2 end)
  end
end

Main.solve()
|> IO.inspect()
