defmodule ConsolidateWeb.CardsController do
  use ConsolidateWeb, :controller
  alias Consolidate.Card
  alias Consolidate.Category
  alias Consolidate.Repo
  import Ecto.Query
  use Consolidate.Util
  alias ConsolidateWeb.Router.Helpers, as: Routes
  import DateTime

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
    func = fn card -> diff(utc_now(), card.last_answered_at) ~> (x * 1.5) |> trunc end
    timeUpdate(conn,id,func)
  end

  def wrong(conn, %{"id" => id}) do
    func = fn card -> diff(card.due_at, card.last_answered_at) ~> (x / 8) |> trunc end
    timeUpdate(conn,id,func)
  end

  def timeUpdate(conn, id, addFunction) do
    card = Repo.get!(Card, id)
    now = utc_now()

    if compare(card.due_at, now) == :lt do
      toAdd = addFunction.(card)

      card
      |> Card.changeset(%{due_at: add(now, toAdd), last_answered_at: now})
      |> Repo.update!()
    end

    redirect(conn, to: Routes.cards_path(conn, :home))
  end

  def processNewCategory(params) do
    {cid, nc, rest} = mapMatch(params, [:category_id, :new_category])

    case cid do
      "new" -> Map.put(rest, :category_id, Category.create!(%{name: nc}).id)
      x -> Map.put(rest, :category_id, x)
    end
  end
end
