defmodule Main do
  def solve do
    {numbers, boards} = IO.binread(:stdio, :eof) |> parse()

    play(numbers, boards)
  end

  defp play([head | numbers], [board | []]) do
    case mark_boards([board], head) do
      [] -> head * (calculate_score(board) - head)
      board -> play(numbers, [board])
    end
  end

  defp play([head | numbers], boards) do
    boards = mark_boards(boards, head)

    play(numbers, boards)
  end

  defp calculate_score(board) do
    Enum.reduce(board, 0, fn line, acc ->
      Enum.reduce(line, acc, fn {state, number}, acc ->
        case state do
          :free -> acc + number
          :taken -> acc
        end
      end)
    end)
  end

  defp mark_boards(boards, number) do
    boards
    |> Enum.map(fn board ->
      Enum.map(board, fn board_line ->
        Enum.map(board_line, fn square ->
          case square do
            {:free, ^number} -> {:taken, number}
            square -> square
          end
        end)
      end)
    end)
    |> Enum.reject(&board_won?/1)
  end

  defp board_won?(board) do
    check_lines(board) ||
      board |> rotate_board |> check_lines
  end

  defp check_lines(board) do
    Enum.any?(board, fn line ->
      Enum.all?(line, fn {state, _val} -> state == :taken end)
    end)
  end

  defp rotate_board(board) do
    Enum.zip_with(board, & &1)
  end

  defp parse(stream) do
    [numbers | boards] = stream |> String.split("\n\n")

    {parse_bingo_numbers(numbers), parse_boards(boards)}
  end

  defp parse_bingo_numbers(numbers) do
    numbers
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  defp parse_boards(boards) do
    boards
    |> Enum.map(fn board ->
      board
      |> String.split("\n")
      |> Enum.map(fn board_line ->
        board_line
        |> String.split(" ")
        |> Enum.reject(&(&1 == ""))
        |> Enum.map(&{:free, String.to_integer(&1)})
      end)
      |> Enum.reject(&(&1 == []))
    end)
  end
end

Main.solve()
|> IO.inspect()
