defmodule Main do
  def solve do
    IO.binread(:stdio, :eof)
    |> parse()
    |> parse_packet()
  end

  defp parse(line) do
    line
    |> String.codepoints()
    |> Enum.map(&hex_to_bin/1)
    |> Enum.reverse()
    |> Enum.reduce(&Kernel.++/2)
  end

  defp parse_packet([v1, v2, v3, id1, id2, id3 | packet]) do
    version = bin_to_int([v1, v2, v3])
    id = bin_to_int([id1, id2, id3])
    {length, value} = dispatch_parsing(id, packet)

    {length + 6, version + value}
  end

  defp parse_packet(padding), do: {length(padding), 0}

  defp dispatch_parsing(id, packet) do
    case id do
      4 -> parse_value(packet)
      id -> parse_operator(id, packet)
    end
  end

  defp parse_value(value) do
    {length, _values} =
      Enum.chunk_every(value, 5)
      |> Enum.reduce_while({0, []}, fn [lead | bits], {length, values} ->
        case [lead] do
          '1' -> {:cont, {length + 5, [bits | values]}}
          '0' -> {:halt, {length + 5, [bits | values]}}
        end
      end)

    # {length, Enum.reduce(values, &Kernel.++/2) |> bin_to_int()}
    {length, 0}
  end

  defp parse_operator(_id, [type | packet]) do
    {length, values} = get_sub_packets([type], packet)

    {length + 1, Enum.sum(values)}
  end

  defp get_sub_packets(
         '0',
         [l1, l2, l3, l4, l5, l6, l7, l8, l9, l10, l11, l12, l13, l14, l15 | _p] = packet
       ) do
    length = bin_to_int([l1, l2, l3, l4, l5, l6, l7, l8, l9, l10, l11, l12, l13, l14, l15])

    Enum.reduce_while(Stream.iterate(0, & &1), {15, []}, fn _n, {index, values} ->
      if index - 15 >= length do
        {:halt, {index, values}}
      else
        {length, value} = parse_packet(Enum.slice(packet, index, 1_000_000_000))
        {:cont, {index + length, [value | values]}}
      end
    end)
  end

  defp get_sub_packets('1', [n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11 | _p] = packet) do
    subpacket_nb = bin_to_int([n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11])

    Enum.reduce(0..subpacket_nb, {11, []}, fn _n, {index, values} ->
      {length, value} = parse_packet(Enum.slice(packet, index, 1_000_000_000))

      {index + length, [value | values]}
    end)
  end

  defp bin_to_int(bin) do
    List.to_integer(bin, 2)
  end

  defp hex_to_bin("0"), do: '0000'
  defp hex_to_bin("1"), do: '0001'
  defp hex_to_bin("2"), do: '0010'
  defp hex_to_bin("3"), do: '0011'
  defp hex_to_bin("4"), do: '0100'
  defp hex_to_bin("5"), do: '0101'
  defp hex_to_bin("6"), do: '0110'
  defp hex_to_bin("7"), do: '0111'
  defp hex_to_bin("8"), do: '1000'
  defp hex_to_bin("9"), do: '1001'
  defp hex_to_bin("A"), do: '1010'
  defp hex_to_bin("B"), do: '1011'
  defp hex_to_bin("C"), do: '1100'
  defp hex_to_bin("D"), do: '1101'
  defp hex_to_bin("E"), do: '1110'
  defp hex_to_bin("F"), do: '1111'
  defp hex_to_bin("\n"), do: []
end

Main.solve()
|> IO.inspect()
