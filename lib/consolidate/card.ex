defmodule Consolidate.Card do
  import Ecto.Changeset
  use Ecto.Schema

  schema "cards" do
    field :answer, :string
    field :due_at, :time
    field :last_answered_at, :time
    field :question, :string
    field :user_id, :integer
    belongs_to :category, Consolidate.Category

    timestamps()
  end

  use Consolidate.Model

  @doc false
  def changeset(card, attrs) do
    card
    |> cast(attrs, [:question, :answer, :last_answered_at, :due_at, :category_id,:user_id])
    |> validate_required([:question, :answer, :last_answered_at, :due_at, :category_id,:user_id])
  end
end

