defmodule Consolidate.Util do
  alias Consolidate.Util

  defmacro __using__(_) do
    quote do
      # easier function access
      import IO, only: [puts: 1]
      import Map, only: [merge: 2]
      import Util
    end
  end

  def atomizeKeys(map) when is_map(map) do
    Map.new(map, fn {k, v} -> {String.to_atom(k), Util.atomizeKeys(v)} end)
  end

  def atomizeKeys(list) when is_list(list) do
    Enum.map(list, &atomizeKeys/1)
  end

  def atomizeKeys(var) do
    var
  end

  # easy access funciton
  def f(key) do
    &Map.fetch!(&1,key)
  end

  # simulate destructuring assignment
  def mapMatch(m, vals) do
    Enum.map(vals, &Map.fetch!(m, &1)) |> List.to_tuple() |> Tuple.append(Map.drop(m, vals))
  end
end
