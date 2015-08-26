defmodule Docopt.Node.Required do
  @module __MODULE__

  defstruct name: nil,
            default: nil,
            children: [nil]

  @type t :: %@module{name: atom, children: list}
end
