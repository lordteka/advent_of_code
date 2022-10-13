defmodule Area do
  defmacro at!(area, pos) do
    quote do
      elem(
        elem(unquote(area), elem(unquote(pos), 1)),
        elem(unquote(pos), 0)
      )
    end
  end

  defmacro height(area) do
    quote do
      tuple_size(unquote(area))
    end
  end

  defmacro width(area) do
    quote do
      tuple_size(elem(unquote(area), 0))
    end
  end

  defguard safe_pos?(area, pos)
           when elem(pos, 0) >= 0 and
                  elem(pos, 1) >= 0 and
                  elem(pos, 1) < height(area) and
                  elem(pos, 0) < width(area)

  def from_string(lines) do
    lines
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split("", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
    |> List.to_tuple()
  end

  def at(map, pos, default \\ nil)
  def at(map, pos, _default) when safe_pos?(map, pos), do: at!(map, pos)
  def at(_, _, default), do: default

  def reduce(area, acc, fun),
    do: reduce(area, {0, 0}, acc, fun)

  def reduce(area, {_x, y}, acc, _fun) when y >= height(area),
    do: acc

  def reduce(area, {x, y}, acc, fun) when x >= width(area),
    do: reduce(area, {0, y + 1}, acc, fun)

  def reduce(area, {x, y} = pos, acc, fun),
    do: reduce(area, {x + 1, y}, fun.({at!(area, pos), pos}, acc), fun)

  def map(area, fun) do
    reduce(area, area, fn {value, pos}, area ->
      put_at(area, pos, fun.(value))
    end)
  end

  def put_at(area, {x, y} = pos, value) when safe_pos?(area, pos) do
    put_elem(
      area,
      y,
      put_elem(
        elem(area, y),
        x,
        value
      )
    )
  end

  def put_at(area, _pos, _value), do: area

  def print(area, path) do
    area
    |> Tuple.to_list()
    |> Enum.with_index()
    |> Enum.each(fn {line, y} ->
      line
      |> Tuple.to_list()
      |> Enum.with_index()
      |> Enum.each(fn {n, x} ->
        if {x, y} in path do
          (IO.ANSI.red() <> Integer.to_string(n) <> IO.ANSI.reset()) |> IO.binwrite()
        else
          n |> Integer.to_string() |> IO.binwrite()
        end
      end)

      IO.binwrite("\n")
    end)

    area
  end
end
