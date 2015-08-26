defmodule Docopt.Node.Repeated do
  @module __MODULE__

  defstruct children: []

  @type t :: %@module{children: list}
end
