defmodule Docopt.PartitionerTest do
  use ExUnit.Case

  import Docopt.Partitioner, only: [partition: 1]

  test "when inital usage is on the same line" do
    docopt = """
    Naval Fate.

    Usage: naval_fate ship new <name>...
           naval_fate ship <name> move <x> <y> [--speed=<kn>]
           naval_fate ship shoot <x> <y>
           naval_fate mine (set|remove) <x> <y> [--moored|--drifting]
           naval_fate -h | --help
           naval_fate --version
    """

    usage = [
      "ship new <name>...",
      "ship <name> move <x> <y> [--speed=<kn>]",
      "ship shoot <x> <y>",
      "mine (set|remove) <x> <y> [--moored|--drifting]",
      "-h | --help",
      "--version"
    ]

    assert partition(docopt) == {usage, []}
  end

  test "when initial usage is on a separete line" do
    docopt = """
    Naval Fate.

    Usage:
      naval_fate ship new <name>...
      naval_fate ship <name> move <x> <y> [--speed=<kn>]
      naval_fate ship shoot <x> <y>
      naval_fate mine (set|remove) <x> <y> [--moored|--drifting]
      naval_fate -h | --help
      naval_fate --version
    """

    usage = [
      "ship new <name>...",
      "ship <name> move <x> <y> [--speed=<kn>]",
      "ship shoot <x> <y>",
      "mine (set|remove) <x> <y> [--moored|--drifting]",
      "-h | --help",
      "--version"
    ]

    assert partition(docopt) == {usage, []}
  end

  test "when an option description is present" do
    docopt = """
    Naval Fate.

    Usage:
      naval_fate ship new <name>...
      naval_fate ship <name> move <x> <y> [--speed=<kn>]
      naval_fate ship shoot <x> <y>
      naval_fate mine (set|remove) <x> <y> [--moored|--drifting]
      naval_fate -h | --help
      naval_fate --version

    -h --help     Show this screen.
    --version     Show version.
    --speed=<kn>  Speed in knots [default: 10].
    --moored      Moored (anchored) mine.
    --drifting    Drifting mine.
    """

    usage = [
      "ship new <name>...",
      "ship <name> move <x> <y> [--speed=<kn>]",
      "ship shoot <x> <y>",
      "mine (set|remove) <x> <y> [--moored|--drifting]",
      "-h | --help",
      "--version"
    ]

    options = [
      "-h --help     Show this screen.",
      "--version     Show version.",
      "--speed=<kn>  Speed in knots [default: 10].",
      "--moored      Moored (anchored) mine.",
      "--drifting    Drifting mine."
    ]

    assert partition(docopt) == {usage, options}
  end

  test "when option description has weird lines" do
    docopt = """
    Naval Fate.

    Usage:
      naval_fate ship new <name>...
      naval_fate ship <name> move <x> <y> [--speed=<kn>]
      naval_fate ship shoot <x> <y>
      naval_fate mine (set|remove) <x> <y> [--moored|--drifting]
      naval_fate -h | --help
      naval_fate --version

    Options:
      -h --help     Show this screen.
      --version     Show version.

      Here is some text separating meta options from program
      options. It won't show up in the options list.

      --speed=<kn>  Speed in knots [default: 10].
      --moored      Moored (anchored) mine.
      --drifting    Drifting mine.
    """

    usage = [
      "ship new <name>...",
      "ship <name> move <x> <y> [--speed=<kn>]",
      "ship shoot <x> <y>",
      "mine (set|remove) <x> <y> [--moored|--drifting]",
      "-h | --help",
      "--version"
    ]

    options = [
      "-h --help     Show this screen.",
      "--version     Show version.",
      "--speed=<kn>  Speed in knots [default: 10].",
      "--moored      Moored (anchored) mine.",
      "--drifting    Drifting mine."
    ]

    assert partition(docopt) == {usage, options}
  end
end
