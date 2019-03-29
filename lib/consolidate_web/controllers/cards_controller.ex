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
      due_at: DateTime.utc_now() |> DateTime.add(5),
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
      destination: Routes.cards_path(conn, :create),
      categories: Category |> Repo.all(),
      changeset: Card.changeset(%Card{}, %{})
    )
  end

  def right(conn, %{"id" => id}) do
    card = Repo.get!(Card,id)

    if DateTime.utc_now() > card.due_at do
      diff = DateTime.diff(DateTime.utc_now(), card.last_answered_at)

      Repo.get!(Card, id)
      |> Card.changeset(%{due_at: DateTime.add(DateTime.utc_now(), diff * 2)})
      |> Repo.update!()
    end

    redirect(conn, to: Routes.cards_path(conn, :home))
  end
  Card |> Repo.all |> Enum.map(f :due_at)
  #Repo.update_all(Card,set: [due_at: DateTime.utc_now()])
  #Repo.update_all(Card,set: [last_answered_at: DateTime.utc_now()])
  #DateTime.utc_now()

  def processNewCategory(params) do
    {cid, nc, rest} = mapMatch(params, [:category_id, :new_category])

    case cid do
      "new" -> Map.put(rest, :category_id, Category.create!(%{name: nc}).id)
      x -> Map.put(rest, :category_id, x)
    end
  end
end
