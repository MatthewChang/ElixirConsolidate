defmodule Consolidate.Util do
  alias Consolidate.Util

  def atomizeKeys(map) when is_map(map) do
    Map.new(map, fn {k, v} -> {String.to_atom(k), Util.atomizeKeys(v)} end)
  end

  def atomizeKeys(list) when is_list(list) do
    Enum.map(list, &atomizeKeys/1)
  end

  def atomizeKeys(var) do
    var
  end

  #easier function access
  def merge(a,b), do: Map.merge(a,b)
end
