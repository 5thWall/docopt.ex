defmodule DocoptTest do
  use ExUnit.Case

  defmodule TestModule do
    use Docopt

    @docopt """
    Test

    Usage:
      test
      test --help

    Options:
      -h --help  Show this screen.
    """
  end

  test "it generates a help function" do
    assert TestModule.parse_args(["-h"])     == {[help: true], [], []}
    assert TestModule.parse_args(["--help"]) == {[help: true], [], []}
  end
end
