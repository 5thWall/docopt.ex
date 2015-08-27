defmodule Docopt.Node.Required do
  @module __MODULE__

  defstruct name: nil,
            default: nil,
            children: [nil]

  @type t :: %@module{name: atom, children: list}

  defimpl Docopt.Node, for: @module do
    alias Docopt.OptionParser, as: OP

    def parse(node, [arg | rest], arg_list) do
      arg_list = [{node.name, arg} | arg_list]
      OP.select_child(node.children, rest, arg_list)
    end
  end
end
