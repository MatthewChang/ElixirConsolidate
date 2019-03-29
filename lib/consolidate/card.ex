defmodule Consolidate.Card do
  import Ecto.Changeset
  use Ecto.Schema

  schema "cards" do
    field :answer, :string
    field :due_at, :utc_datetime
    field :last_answered_at, :utc_datetime
    field :question, :string
    belongs_to :category, Consolidate.Category, [on_replace: :update]
    belongs_to :user, Consolidate.User, [on_replace: :update]

    timestamps()
  end

  use Consolidate.Model

  @doc false
  def changeset(card, attrs) do
    card
    |> cast(attrs, [:question, :answer, :last_answered_at, :due_at, :category_id, :user_id])
    |> validate_required([:question, :answer, :last_answered_at, :due_at, :category_id, :user_id])
  end
end
