defmodule Main do
  def solve do
    {dots, folds} = IO.binread(:stdio, :eof) |> parse()

    Enum.reduce(folds, dots, &fold_sheet(&2, &1))
    |> print_dots
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

  defp order_dots(dots) do
    Enum.sort(dots, fn {x1, y1}, {x2, y2} ->
      if y1 == y2 do
        x1 <= x2
      else
        y1 <= y2
      end
    end)
  end

  defp print_dots(dots) do
    dots
    |> order_dots()
    |> print_dots({0, 0})
  end

  defp print_dots([], _) do
    IO.write("\n")
    :ok
  end

  defp print_dots(_dots, {_x, y}) when y > 50, do: :ok

  defp print_dots(dots, {x, y}) when x > 50 do
    IO.write("\n")
    print_dots(dots, {0, y + 1})
  end

  defp print_dots([{x, y} | tail], {x, y}) do
    IO.write("#")
    print_dots(tail, {x + 1, y})
  end

  defp print_dots(dots, {x, y}) do
    IO.write(".")
    print_dots(dots, {x + 1, y})
  end
end

Main.solve()
|> IO.inspect()
