Code.require_file("area.exs")

defmodule FastMap do
  def new(width, height, default \\ nil) do
    {width, Tuple.duplicate(default, width * height + 1)}
  end

  def at({w, map}, pos) do
    elem(map, index(w, pos))
  end

  def put({w, map}, pos, e) do
    {w, put_elem(map, index(w, pos), e)}
  end

  def index(w, {x, y}) do
    w * y + x
  end

  def reverse_index(w, pos) do
    {rem(pos, w), div(pos, w)}
  end
end

defmodule Main do
  require Area

  def solve do
    area = IO.binread(:stdio, :eof) |> parse()

    shortest_path(area, {0, 0}, {Area.width(area) - 1, Area.height(area) - 1})
  end

  defp parse(lines) do
    Area.from_string(lines)
  end

  defp shortest_path(area, source, dest) do
    path =
      loop(area, init_data(area, source), source, dest)
      |> build_path(source, dest)

    Area.print(area, path)
    |> path_risk(path)
  end

  defp init_data(area, source) do
    {
      FastMap.new(Area.width(area), Area.height(area), 1_000_000_000_000)
      |> FastMap.put(source, 0),
      FastMap.new(Area.width(area), Area.height(area)),
      MapSet.new(0..(Area.width(area) * Area.width(area)))
    }
  end

  defp loop(_area, {_dist, prev, _unvisited}, source, source), do: prev

  defp loop(area, {_dist, _prev, unvisited} = data, source, dest) do
    {dist, prev} = update_data(area, data, source)

    unvisited = remove_from_unvisited(unvisited, source, dist)

    next_pos = next_pos(dist, unvisited)

    loop(area, {dist, prev, unvisited}, next_pos, dest)
  end

  defp update_data(area, {{w, _} = dist, prev, unvisited}, pos) do
    Enum.reduce(neighbours(pos, unvisited, w), {dist, prev}, fn neighbour, {dist, prev} = data ->
      neighbour = FastMap.reverse_index(w, neighbour)
      alt = FastMap.at(dist, pos) + Area.at(area, neighbour, 10)

      if alt < FastMap.at(dist, neighbour) do
        {
          FastMap.put(dist, neighbour, alt),
          FastMap.put(prev, neighbour, pos)
        }
      else
        data
      end
    end)
  end

  defp neighbours({x, y}, unvisited, w) do
    [
      {x - 1, y},
      {x + 1, y},
      {x, y - 1},
      {x, y + 1}
    ]
    |> Enum.reject(fn {x, y} -> x < 0 or y < 0 or x >= w or y >= w end)
    |> Enum.map(fn {x, y} -> x + y * w end)
    |> MapSet.new()
    |> MapSet.intersection(unvisited)
  end

  defp remove_from_unvisited(unvisited, pos, {w, _}) do
    MapSet.delete(unvisited, FastMap.index(w, pos))
  end

  defp next_pos({w, dist}, unvisited) do
    {index, _} =
      Enum.reduce(unvisited, {-1, 1_000_000_000_000}, fn pos, {_, min} = acc ->
        if elem(dist, pos) < min do
          {pos, elem(dist, pos)}
        else
          acc
        end
      end)

    FastMap.reverse_index(w, index)
  end

  defp build_path(prev, source, dest), do: build_path(prev, source, dest, [dest])
  defp build_path(_prev, source, source, path), do: path

  defp build_path(prev, source, dest, path) do
    build_path(prev, source, FastMap.at(prev, dest), [FastMap.at(prev, dest) | path])
  end

  defp path_risk(area, path) do
    Enum.reduce(
      path,
      0 - Area.at(area, {0, 0}),
      &(&2 + Area.at(area, &1))
    )
  end
end

Main.solve()
|> IO.inspect()
