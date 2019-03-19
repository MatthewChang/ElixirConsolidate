defmodule ConsolidateWeb.CardsController do
  use ConsolidateWeb, :controller
  alias Consolidate.Card
  alias Consolidate.Category
  alias Consolidate.Repo
  import Ecto.Query

  def index(conn, _params) do
    render(conn, "index.html", cards: Card |> preload(:category) |> Repo.all)
  end

  def new(conn, _params) do
    render(conn, "new.html", categories: Category |> Repo.all, changeset: Card.changeset(%Card{},%{}))
  end
end

