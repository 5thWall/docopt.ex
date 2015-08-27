defmodule Docopt.OptionParser do
  @omduledoc """
  Module responsible for parsing an argument list using a parse tree
  as a guide.
  """

  require Logger

  alias Docopt.AnswerSelector

  def parse(tree, argv, arg_list \\ [])

  def parse(nil, [], arg_list),
  do: {:ok, Enum.reverse(arg_list)}

  def parse(nil, argv, arg_list) do
    err = {:error,
           "Parse tree ran out",
           [argv: argv, arg_list: arg_list]}
    Logger.info inspect(err)
    err
  end

  def parse(tree, argv, arg_list),
  do: Docopt.Node.parse(tree, argv, arg_list)

  def select_child(nil, args, arg_list) do
    err = {:error,
           "Parse tree ran out",
           [argv: args, arg_list: arg_list]}
    Logger.info inspect(err)
    err
  end

  def select_child(nodes, args, arg_list) do
    Logger.info "Checking kids"
    nodes
    |> Enum.map(&(parse(&1, args, arg_list)))
    |> AnswerSelector.select
  end
end
