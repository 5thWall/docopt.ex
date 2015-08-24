defmodule Docopt do
  @moduledoc """
  """

  defmacro __using__(_options) do
    quote do
      import unquote(__MODULE__)
      @before_compile unquote(__MODULE__)
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def parse_args(argv) do
        OptionParser.parse(argv, switches: switches, aliases: aliases)
      end

      def switches do
        [:help]
      end

      def aliases do
        [h: :help]
      end
    end
  end
end
