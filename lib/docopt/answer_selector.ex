defmodule Docopt.AnswerSelector do
  @moduledoc """
  """

  def select({[], errors}) do
    errors
    |> Enum.max_by(fn
      {:error, _, list} -> Enum.count(list[:argv])
    end)
  end

  def select({answers, _}) do
    answers
    |> Enum.min_by(fn {:ok, list} -> Enum.count(list) end)
  end

  def select(list) do
    list
    |> Enum.partition(fn
      {:ok, _}       -> true
      {:error, _, _} -> false
    end)
    |> select
  end
end
