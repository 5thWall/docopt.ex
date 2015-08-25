defmodule Docopt.Partitioner do
  @moduledoc """
  Utility module responsible for partitiona Docopts into
  'usage` and `option` portions
  """

  import String, only: [split: 1, starts_with?: 2]

  def partition(docopt) do
    docopt
    |> String.split("\n")
    |> Enum.map(&String.strip/1)
    |> do_initial_partition
  end

  defp do_initial_partition(["Usage: " <> line | rest]) do
    [name | line] = line |> split
    do_usage_partition(name, rest, [Enum.join(line, " ")])
  end

  defp do_initial_partition(["Usage:", line | rest]) do
    [name | line] = line |> split
    do_usage_partition(name, rest, [Enum.join(line, " ")])
  end

  defp do_initial_partition([_hd | rest]) do
    do_initial_partition(rest)
  end

  defp do_usage_partition(_, [], usage) do
    {Enum.reverse(usage), []}
  end

  defp do_usage_partition(_, ["" | rest], usage) do
    {Enum.reverse(usage), do_option_partition(rest)}
  end

  defp do_usage_partition(name, [line | rest], usage) do
    case Regex.run(~r/#{name}\s+(.+)/, line) do
      [_, line] -> do_usage_partition(name, rest, [line | usage])
      _         -> do_usage_partition(name, rest, usage)
    end
  end

  defp do_option_partition(options) do
    options |> Enum.filter(&(starts_with?(&1, "-")))
  end
end
