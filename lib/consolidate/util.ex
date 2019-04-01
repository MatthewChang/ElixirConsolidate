defmodule Consolidate.Util do
  alias Consolidate.Util

  defmacro __using__(_) do
    quote do
      # easier function access
      import IO, only: [puts: 1]
      import Map, only: [merge: 2]
      import Util
      alias Consolidate.Util
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
    &Map.fetch!(&1, key)
  end

  def f(map, key) do
    Map.fetch!(map, key)
  end

  def snd({_,b}), do: b

  def fst({a,_}), do: a

  def uncurry(f), do: fn {a,b} -> f.(a,b) end

  # simulate destructuring assignment
  def mapMatch(m, vals) do
    Enum.map(vals, &Map.fetch!(m, &1)) |> List.to_tuple() |> Tuple.append(Map.drop(m, vals))
  end

  # helper for macro below
  def replaceToken(t1, t2, arg, node) do
    case node do
      {s, c, args} ->
        if s == t1,
          do: {t2, c, arg},
          else: {replaceToken(t1, t2, arg, s), c, replaceToken(t1, t2, arg, args)}

      node when is_list(node) ->
        Enum.map(node, &replaceToken(t1, t2, arg, &1))

      _ ->
        node
    end
  end

  # macro for nicer syntax lambda chains
  defmacro a ~> b do
    quote do
      unquote(a) |> (&unquote(Util.replaceToken(:x, :&, [1], b))).()
    end
  end
end
