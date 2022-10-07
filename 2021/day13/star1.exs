defmodule Main do
  def solve do
    {dots, folds} = IO.binread(:stdio, :eof) |> parse()

    fold_sheet(dots, hd(folds))
    |> Enum.count()
  end

  defp parse(file) do
    [dots, folds] = String.split(file, "\n\n", trim: true)

    {parse_dots(dots), parse_folds(folds)}
  end

  defp parse_dots(lines) do
    lines
    |> String.split("\n", trim: true)
    |> Enum.map(fn dot ->
      String.split(dot, ",", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
  end

  defp parse_folds(lines) do
    lines
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      ~r/([x|y])=(\d+)/
      |> Regex.run(line, capture: :all_but_first)
      |> List.to_tuple()
    end)
    |> Enum.map(&format_folds/1)
  end

  defp format_folds({"x", i}), do: {:x, String.to_integer(i)}
  defp format_folds({"y", i}), do: {:y, String.to_integer(i)}

  defp fold_sheet(dots, fold) do
    Enum.map(dots, &fold(&1, fold))
    |> Enum.uniq()
  end

  defp fold({x, _y}, {:x, x}), do: nil
  defp fold({x, _y} = dot, {:x, i}) when x < i, do: dot
  defp fold({x, y}, {:x, i}), do: {2 * i - x, y}

  defp fold({_x, y}, {:y, y}), do: nil
  defp fold({_x, y} = dot, {:y, i}) when y < i, do: dot
  defp fold({x, y}, {:y, i}), do: {x, 2 * i - y}
end

Main.solve()
|> IO.inspect()
