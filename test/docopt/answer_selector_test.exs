defmodule Docopt.AnswerSelectorTest do
  use ExUnit.Case

  import Docopt.AnswerSelector, only: [select: 1]

  test "selects shortest :ok value" do
    answers = [
      {:ok, [foo: "foo",
             bar: "bar",
             baz: "baz"]},
      {:ok, [foo: "foo",
             bar: "bar"]},
      {:ok, [foo: "foo",
             bar: "bar",
             baz: "baz",
             fiz: "fiz",
             buz: "buz"]}
    ]

    assert select(answers) == {:ok, [foo: "foo", bar: "bar"]}
  end

  test "selects longest :error value" do
    answers = [
      {:error, "Thing", [argv: ["foo", "bar", "baz"],
                         tree: [], arg_list: []]},
      {:error, "Thing", [argv: ["foo", "bar"],
                         tree: [], arg_list: []]},
      {:error, "Thing", [argv: ["foo", "bar", "baz", "fiz"],
                         tree: [], arg_list: []]}
    ]

    assert select(answers) == {:error,
                               "Thing",
                               [argv: ["foo", "bar", "baz", "fiz"],
                                tree: [],
                                arg_list: []]}
  end

  test "selects :ok from mixed values" do
    answers = [
      {:ok, [foo: "foo",
             bar: "bar",
             baz: "baz"]},
      {:error, "Thing", [argv: ["foo", "bar", "baz", "fiz"],
                         tree: [], arg_list: []]},
      {:error, "Thing", [argv: ["foo", "bar"],
                         tree: [], arg_list: []]},
      {:ok, [foo: "foo",
             bar: "bar"]},
      {:error, "Thing", [argv: ["foo", "bar", "baz"],
                         tree: [], arg_list: []]},
      {:ok, [foo: "foo",
             bar: "bar",
             baz: "baz",
             fiz: "fiz",
             buz: "buz"]}
    ]

    assert select(answers) == {:ok, [foo: "foo", bar: "bar"]}
  end
end
