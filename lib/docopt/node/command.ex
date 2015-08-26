defmodule Docopt.Node.Command do
  @module __MODULE__

  defstruct name: nil,
            value: "",
            children: [nil]

  @type t :: %@module{name: atom, value: String.t, children: list}
end
