defmodule ConsolidateWeb.CardsController do
  use ConsolidateWeb, :controller
  alias Consolidate.Card
  alias Consolidate.Category
  alias Consolidate.Repo
  import Ecto.Query
  use Consolidate.Util
  alias ConsolidateWeb.Router.Helpers, as: Routes

  def home(conn, _params) do
    render(conn, "home.html",
      card: Card |> order_by(asc: :due_at) |> preload(:category) |> first |> Repo.one()
    )
  end

  def index(conn, _params) do
    render(conn, "index.html", cards: Card |> preload(:category) |> Repo.all())
  end

  def edit(conn, %{"id" => id}) do
    render(conn, "new.html",
      destination: Routes.cards_path(conn, :update, id),
      categories: Category |> Repo.all(),
      changeset: Card.changeset(Card.find(id), %{})
    )
  end

  def new(conn, _params) do
    render(conn, "new.html",
      destination: Routes.cards_path(conn, :create),
      categories: Category |> Repo.all(),
      changeset: Card.changeset(%Card{}, %{})
    )
  end

  def update(conn, %{"id" => id, "card" => card_params}) do
    card_params = atomizeKeys(card_params) |> processNewCategory
    Card.changeset(Card.find(id), card_params) |> Repo.update!()

    conn
    |> put_flash(:info, "Card Updated #{id}")
    |> redirect(to: Routes.cards_path(conn, :edit, id))
  end

  def create(conn, %{"card" => card_params}) do
    card_params = atomizeKeys(card_params) |> processNewCategory
    user = Guardian.Plug.current_resource(conn)

    attrs = %{
      due_at: DateTime.utc_now() |> Time.add(5),
      last_answered_at: DateTime.utc_now(),
      user_id: user.id
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

  def processNewCategory(params) do
    {cid, nc, rest} = mapMatch(params, [:category_id, :new_category])

    nid =
      case cid do
        "new" -> Category.create!(%{name: nc}).id
        x -> x
      end

    merge(rest, %{category_id: nid})
  end
end
