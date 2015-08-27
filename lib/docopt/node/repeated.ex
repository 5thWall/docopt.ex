defmodule Docopt.Node.Repeated do
  @module __MODULE__

  defstruct children: []

  @type t :: %@module{children: list}

  defimpl Docopt.Node, for: @module do
    require Logger

    alias Docopt.AnswerSelector
    alias Docopt.OptionParser, as: OP

    def parse(n, argv, arg_list) do
      Logger.info "Parsing repeating"

      n.children
      |> Enum.map(&(OP.parse(&1, argv, arg_list)))
      |> Enum.map(fn
        {:error, "Parse tree ran out", args} ->
            Logger.debug "Repeating"
            parse(n, args[:argv], args[:arg_list])
        other ->
          Logger.debug inspect(other)
          other
      end)
      |> AnswerSelector.select
    end
  end
end
