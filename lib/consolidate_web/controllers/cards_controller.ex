defmodule ConsolidateWeb.CardsController do
  use ConsolidateWeb, :controller
  alias Consolidate.Card
  alias Consolidate.Category
  alias Consolidate.Repo
  import Ecto.Query
  import Consolidate.Util

  def home(conn, _params) do
    render(conn, "home.html",
      card: Card |> order_by(asc: :due_at) |> preload(:category) |> first |> Repo.one()
    )
  end

  def index(conn, _params) do
    render(conn, "index.html", cards: Card |> preload(:category) |> Repo.all())
  end

  def new(conn, _params) do
    render(conn, "new.html",
      categories: Category |> Repo.all(),
      changeset: Card.changeset(%Card{}, %{})
    )
  end

  def create(conn, %{"card" => card_params}) do
    card_params = atomizeKeys(card_params)
    user = Guardian.Plug.current_resource(conn)

    cid =
      case card_params.category_id do
        "new" -> Category.create!(%{name: card_params.new_category}).id
        x -> x
      end

    attrs = %{
      due_at: DateTime.utc_now() |> Time.add(5),
      last_answered_at: DateTime.utc_now(),
      user_id: user.id,
      category_id: cid
    }

    card =
      card_params
      |> merge(attrs)
      |> Card.create!()

    conn
    |> put_flash(:info, "Card Added #{card.id}")
    |> render("new.html",
      categories: Category |> Repo.all(),
      changeset: Card.changeset(%Card{}, %{})
    )
  end
end
