defmodule Docopt.OptionParserTest do
  use ExUnit.Case

  import Docopt.OptionParser, only: [parse: 2]

  alias Docopt.Node.Required
  alias Docopt.Node.Command
  alias Docopt.Node.Repeated

  test "simple positional arguments" do
    file     = %Required{name: :file}
    bar      = %Required{name: :bar, children: [file]}
    opt_tree = %Required{name: :foo, children: [bar]}

    argv = ["foo", "bar", "foo.ex"]

    assert parse(argv, opt_tree) == {:ok, [foo: "foo", bar: "bar", file: "foo.ex"]}
  end

  test "positional commands and args" do
    y    = %Required{name: :y}
    x    = %Required{name: :x, children: [y]}
    move = %Command{name: :move, value: "move", children: [x]}
    name = %Required{name: :name, children: [move]}
    ship = %Command{name: :ship, value: "ship", children: [name]}

    argv = ["ship", "Beagle", "move", "10", "13"]
    parsed = [ship: true, name: "Beagle", move: true, x: "10", y: "13"]

    assert parse(argv, ship) == {:ok, parsed}
  end

  test "positional exclusive arguments" do
    y    = %Required{name: :y}
    x    = %Required{name: :x, children: [y]}
    set = %Command{name: :set, value: "set", children: [x]}
    remove = %Command{name: :remove, value: "remove", children: [x]}
    mine = %Command{name: :mine, value: "mine", children: [set, remove]}

    argv = ["mine", "remove", "10", "45"]
    parsed = [mine: true, remove: true, x: "10", y: "45"]

    assert parse(argv, mine) == {:ok, parsed}
  end

  # test "repeated arguments" do
  #   value = %Required{name: :value}
  #   sep   = %Command{name: :sep, value: ",", children: [value]}
  #   rep   = %Repeated{children: [sep]}
  #   tree  = %Required{name: :value, children: [rep]}

  #   argv = ["10", ",", "20", ",", "30"]
  #   parsed = [value: "10", sep: true, value: "20", sep: true, value: "30"]

  #   assert parse(argv, tree) == {:ok, parsed}
  # end
end
