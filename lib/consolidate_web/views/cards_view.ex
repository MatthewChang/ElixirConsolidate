defmodule ConsolidateWeb.CardsView do
  use ConsolidateWeb, :view
  use Consolidate.Util
  import Enum

  def diffText(t1, t2) do
    diffs = DateTime.diff(t1, t2)

    denom = [
      {"seconds", 1},
      {"minutes", 60},
      {"hours", 60}
    ]

    counts = denom |> scan(diffs, fn {_, c}, a -> trunc(a / c) end)
    mods = denom |> drop(1) |> map(&snd/1)
    capped = zip(drop(counts, -1), mods) |> map(uncurry(&rem/2))
    res = capped ++ take(counts, -1)

    zip(res, denom)
    |> reverse
    |> drop_while(fn {v, _} -> v == 0 end)
    |> take(2)
    |> flat_map(fn {v, {l, _}} -> [v, l] end)
    |> join(" ")
  end
end

# Card |> last |> Repo.one |> Card.changeset(%{due_at: DateTime.add(DateTime.utc_now(),-60)}) |> Repo.update!
