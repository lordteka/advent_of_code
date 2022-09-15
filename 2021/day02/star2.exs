defmodule Main do
  def solve do
    IO.binstream()
    |> parse()
    |> Enum.reduce({0, 0, 0}, &execute(&1, &2))
    |> IO.inspect()
  end

  defp parse(stream) do
    stream
    |> Enum.map(&(&1 |> apply_regex |> line_to_command))
  end

  defp apply_regex(line) do
    ~r/([[:alpha:]]+) ([[:digit:]])/
    |> Regex.run(line, capture: :all_but_first)
  end

  defp line_to_command(["forward", x]),
    do: {:forward, String.to_integer(x)}

  defp line_to_command(["up", x]),
    do: {:up, String.to_integer(x)}

  defp line_to_command(["down", x]),
    do: {:down, String.to_integer(x)}

  defp execute({:up, x}, {pos, depth, aim}), do: {pos, depth, aim - x}
  defp execute({:down, x}, {pos, depth, aim}), do: {pos, depth, aim + x}

  defp execute({:forward, x}, {pos, depth, aim}),
    do: {pos + x, depth + aim * x, aim}
end

Main.solve()
|> Tuple.delete_at(2)
|> Tuple.product()
|> IO.inspect()
