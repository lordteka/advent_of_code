defmodule Main do
  def solve do
    IO.binread(:stdio, :eof)
    |> parse()
    |> build_all_path()
    |> Enum.count()
  end

  defp parse(file) do
    file
    |> String.split("\n", trim: true)
    |> Enum.reduce(%{}, fn line, acc ->
      ~r/(\w+)-(\w+)/
      |> Regex.run(line, capture: :all_but_first)
      |> build_graph(acc)
    end)
  end

  defp build_graph([n, m], graph) do
    graph
    |> set_link(n, m)
    |> set_link(m, n)
  end

  defp set_link(graph, n, m) do
    case Map.get(graph, n) do
      nil -> Map.put(graph, n, [m])
      v -> Map.put(graph, n, [m | v])
    end
  end

  defp build_all_path(graph) do
    Enum.flat_map(Map.get(graph, "start"), fn node ->
      explore(graph, node, ["start"], ["start"])
    end)
  end

  defp explore(_, "end", path, _), do: [["end" | path]]
  defp explore(graph, current_node, path, already_visited) do
    case Map.get(graph, current_node) -- already_visited do
      [] ->
        []
      [^current_node] ->
        []
      next_caves ->
        Enum.flat_map(next_caves, fn node ->
          if String.upcase(current_node) == current_node do
            explore(graph, node, [current_node | path], already_visited)
          else
            explore(graph, node, [current_node | path], [current_node | already_visited])
          end
        end)
    end
  end
end

Main.solve()
|> IO.inspect()
