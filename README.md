`docopt.ex` - command line option parser, that will make you smile
==================================================================

An Elixir port of [`docopt`](http://docopt.org).

```elixir
defmodule NavalFate.CLI do
  use Docopt

  @app NavalFate

  @docopt """
  Naval Fate.

  Usage:
    #{@app} ship new <name>...
    #{@app} ship <name> move <x> <y> [--speed=<kn>]
    #{@app} ship shoot <x> <y>
    #{@app} mine (set|remove) <x> <y> [--moored|--drifting]
    #{@app} -h | --help
    #{@app} --version

  Options:
    -h --help     Show this screen.
    --version     Show version.
    --speed=<kn>  Speed in knots [default: 10].
    --moored      Moored (anchored) mine.
    --drifting    Drifting mine.
  """

  def run(options) do
  end
end
```
