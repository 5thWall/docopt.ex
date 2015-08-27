defmodule Docopt.Node.Command do
  @module __MODULE__

  defstruct name: nil,
            value: "",
            children: [nil]

  @type t :: %@module{name: atom, value: String.t, children: list}

  defimpl Docopt.Node, for: @module do
    require Logger

    alias Docopt.Node.Command
    alias Docopt.OptionParser, as: OP

    def parse(node = %Command{value: val} ,[val | rest], arg_list) do
      Logger.info "Parsing command"
      arg_list = [{node.name, true} | arg_list]
      OP.select_child(node.children, rest, arg_list)
    end

    def parse(tree, argv, arg_list) do
      err = {:error,
             "Command does not match",
             [argv: argv, tree: tree, arg_list: arg_list]}
      Logger.info inspect(err)
      err
    end
  end
end
