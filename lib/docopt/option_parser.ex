defmodule Docopt.OptionParser do
  @omduledoc """
  Module responsible for parsing an argument list using a parse tree
  as a guide.
  """

  require Logger

  alias Docopt.AnswerSelector
  alias Docopt.Node.Required
  alias Docopt.Node.Command
  alias Docopt.Node.Repeated

  def parse(argv, tree),
  do: do_parse(argv, tree, [])

  defp do_parse([], nil, arg_list) do
    {:ok, Enum.reverse(arg_list)}
  end

  defp do_parse([], tree, arg_list) do
    err = {:error,
           "Arg list ran out",
           [tree: tree, arg_list: arg_list]}
    Logger.info inspect(err)
    err
  end

  defp do_parse(argv, nil, arg_list) do
    err = {:error,
           "Parse tree ran out",
           [argv: argv, arg_list: arg_list]}
    Logger.info inspect(err)
    err
  end

  defp do_parse([arg | rest], node = %Command{value: arg}, arg_list) do
    Logger.info "Parsing command"
    arg_list = [{node.name, true} | arg_list]
    select_child(rest, node.children, arg_list)
  end

  defp do_parse(argv, tree = %Command{}, arg_list) do
    err = {:error,
           "Command does not match",
           [argv: argv, tree: tree, arg_list: arg_list]}
    Logger.info inspect(err)
    err
  end

  defp do_parse([arg | rest], node = %Required{}, arg_list) do
    Logger.info "Parsing required"
    arg_list = [{node.name, arg} | arg_list]
    select_child(rest, node.children, arg_list)
  end

  defp do_parse(argv, n = %Repeated{}, arg_list) do
    Logger.info "Parsing repeating"

    n.children
    |> Enum.map(&(do_parse(argv, &1, arg_list)))
    |> Enum.map(fn
      {:error, "Parse tree ran out", args} ->
          Logger.debug "Repeating"
          do_parse(args[:argv], n, args[:arg_list])
      other ->
        Logger.debug inspect(other)
        other
    end)
    |> AnswerSelector.select
  end

  defp do_parse(argv, tree, arg_list) do
    err = {:error,
           "I don't even know",
           [argv: argv, tree: tree, arg_list: arg_list]}
    Logger.info inspect(err)
    err
  end

  defp select_child(args, nil, arg_list) do
    err = {:error,
           "Parse tree ran out",
           [argv: nil, arg_list: arg_list]}
    Logger.info inspect(err)
    err
  end

  defp select_child(args, nodes, arg_list) do
    Logger.info "Checking kids"
    nodes
    |> Enum.map(&(do_parse(args, &1, arg_list)))
    |> AnswerSelector.select
  end
end
