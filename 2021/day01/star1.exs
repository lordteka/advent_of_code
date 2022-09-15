defmodule Main do
  def solve do
    IO.binstream
    |> Enum.reduce({0, -1}, &higher_than_before(&1, &2))
    |> IO.inspect
  end

  def higher_than_before(line, {previous, count}) do
    case depth(line) do
      x when x > previous -> {x, count + 1}
      x -> {x, count}
    end
  end

  def depth(line) do
    case Integer.parse(line) do
      {int, _} -> int
      _ -> :error
    end
  end
end

Main.solve
