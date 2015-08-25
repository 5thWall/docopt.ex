defmodule Docopt.Parser do
  @moduledoc """
  Module for parsing Docopt descriptions and returning
  usefull information.
  """

  import Docopt.Partitioner, only: [partition: 1]

  def parse(docopt) do
    {usage, optiondesc} = partition(docopt)
  end
end
