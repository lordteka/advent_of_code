defmodule Main do
  def solve do
    IO.binstream
    |> Enum.map(&to_int(&1))
    |> format()
    |> Enum.reduce({0, -1}, &higher_than_before(&1, &2))
    |> IO.inspect
  end

  def format(enum) do
    enum
    |> Enum.with_index
    |> Enum.map(fn {_, index} -> Enum.slice(enum, Range.new(index, index + 2, 1)) end)
  end

  def higher_than_before([a, b, c], {previous, count}) do
    case a + b + c do
      x when x > previous -> {x, count + 1}
      x -> {x, count}
    end
  end

  def higher_than_before(_line, acc), do: acc

  def to_int(line) do
    case Integer.parse(line) do
      {int, _} -> int
      _ -> :error
    end
  end
end

Main.solve
