defmodule Main do
  def solve do
    IO.binread(:stdio, :eof)
    |> parse()
    |> ordered_indexes()
    |> Enum.sum()
  end

  defp parse(file) do
    file
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn list_couple ->
      list_couple
      |> String.split("\n", trim: true)
      |> Enum.map(&string_to_list/1)
      |> List.to_tuple()
    end)
  end

  defp string_to_list(string) do
    {list, _binding} = Code.eval_string(string)
    list
  end

  defp ordered_indexes(lists) do
    lists
    |> Enum.with_index(1)
    |> Enum.flat_map(fn {t, i} ->
      if ordered?(t) do
        [i]
      else
        []
      end
    end)
  end

  defp ordered?({l1, l2}), do: compare(l1, l2)

  defp ordered?(l1, l2) do
    Enum.reduce_while(Stream.zip(l1, l2), :next, fn {e1, e2}, _acc ->
      case compare(e1, e2) do
        :next -> {:cont, :next}
        bool -> {:halt, bool}
      end
    end)
  end

  defp compare(e1, e1), do: :next
  defp compare(e1, e2) when is_integer(e1) and is_integer(e2), do: e1 < e2
  defp compare(e1, e2) when is_list(e1) and is_integer(e2), do: compare(e1, [e2])
  defp compare(e1, e2) when is_integer(e1) and is_list(e2), do: compare([e1], e2)

  defp compare(e1, e2) when is_list(e1) and is_list(e2) do
    case ordered?(e1, e2) do
      :next -> if length(e1) == length(e2), do: :next, else: length(e1) < length(e2)
      bool -> bool
    end
  end
end

Main.solve()
|> IO.inspect()
