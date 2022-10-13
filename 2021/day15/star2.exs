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

defmodule PhantomArea do
  require Area

  defdelegate width(area), to: Area
  defdelegate height(area), to: Area
  defdelegate at!(area, pos), to: Area
  defdelegate from_string(lines), to: Area

  defguard safe_pos?(area, pos)
           when elem(pos, 0) >= 0 and
                  elem(pos, 1) >= 0 and
                  elem(pos, 1) < Area.height(area) * 5 and
                  elem(pos, 0) < Area.width(area) * 5

  def at(map, pos, default \\ nil)

  def at(map, {x, y} = pos, _default) when safe_pos?(map, pos) do
    w = width(map)
    original = at!(map, {rem(x, w), rem(y, w)})
    new = original + div(x, w) + div(y, w)

    if new == original do
      original
    else
      case rem(new, 9) do
        0 -> 9
        v -> v
      end
    end
  end

  def at(_, _, default), do: default

  def print(area, path) do
    Enum.each(0..(height(area) * 5 - 1), fn y ->
      Enum.each(0..(width(area) * 5 - 1), fn x ->
        if {x, y} in path do
          (IO.ANSI.red() <> Integer.to_string(at(area, {x, y})) <> IO.ANSI.reset())
          |> IO.binwrite()
        else
          at(area, {x, y}) |> Integer.to_string() |> IO.binwrite()
        end
      end)

      IO.binwrite("\n")
    end)

    area
  end
end

defmodule Main do
  def solve do
    area = IO.binread(:stdio, :eof) |> parse()

    shortest_path(
      area,
      {0, 0},
      {PhantomArea.width(area) * 5 - 1, PhantomArea.height(area) * 5 - 1}
    )
  end

  defp parse(lines) do
    PhantomArea.from_string(lines)
  end

  defp shortest_path(area, source, dest) do
    path =
      loop(area, init_data(area, source), source, dest)
      |> build_path(source, dest)

    # PhantomArea.print(area, path)
    path_risk(area, path)
  end

  defp init_data(area, source) do
    {
      FastMap.new(PhantomArea.width(area) * 5, PhantomArea.height(area) * 5, 1_000_000_000_000)
      |> FastMap.put(source, 0),
      FastMap.new(PhantomArea.width(area) * 5, PhantomArea.height(area) * 5),
      MapSet.new(0..(PhantomArea.width(area) * 5 * PhantomArea.width(area) * 5))
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
      alt = FastMap.at(dist, pos) + PhantomArea.at(area, neighbour, 10)

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
      0 - PhantomArea.at(area, {0, 0}),
      &(&2 + PhantomArea.at(area, &1))
    )
  end
end

Main.solve()
|> IO.inspect()
