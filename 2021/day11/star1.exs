Code.require_file("area.exs")

defmodule Main do
  require Area

  def solve do
    {_map, flash_nb} =
      IO.binread(:stdio, :eof)
      |> parse()
      |> run_step(100)

    flash_nb
  end

  defp parse(lines) do
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

  defp run_step(map, times) do
    Enum.reduce(1..times, {map, 0}, fn _step, {map, flash_nb} ->
      {new_map, pos_flashed} =
        map
        |> increase_energy_levels()
        |> trigger_flash()

      {
        reset(new_map, pos_flashed),
        flash_nb + length(pos_flashed)
      }
    end)
  end

  defp increase_energy_levels(area), do: Area.map(area, &(&1 + 1))

  defp trigger_flash(area) do
    Area.reduce(area, {area, []}, fn {value, pos}, {area, flashed} = acc ->
      if value > 9 do
        flash(area, pos, flashed)
      else
        acc
      end
    end)
  end

  defp flash(area, pos, flashed) when not Area.safe_pos?(area, pos),
    do: {area, flashed}

  defp flash(map, pos, flashed) when Area.at!(map, pos) > 9 do
    if pos in flashed do
      {map, flashed}
    else
      neighbour_flashed(pos, flashed)
      |> Enum.reduce(
        {map, [pos | flashed]},
        fn next_pos, {map, flashed} ->
          map
          |> raise_level(next_pos)
          |> flash(next_pos, flashed)
        end
      )
    end
  end

  defp flash(area, _pos, flashed), do: {area, flashed}

  defp neighbour_flashed({x, y}, flashed) do
    [
      {x - 1, y - 1},
      {x, y - 1},
      {x + 1, y - 1},
      {x - 1, y},
      {x + 1, y},
      {x - 1, y + 1},
      {x, y + 1},
      {x + 1, y + 1}
    ] -- flashed
  end

  def reset(area, flashed),
    do: Enum.reduce(flashed, area, &reset_level(&2, &1))

  defp raise_level(area, pos),
    do: Area.put_at(area, pos, Area.at(area, pos, 0) + 1)

  defp reset_level(area, pos),
    do: Area.put_at(area, pos, 0)
end

Main.solve()
|> IO.inspect()
