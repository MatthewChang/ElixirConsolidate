defmodule Consolidate.Repo.Migrations.CreateCards do
  use Ecto.Migration

  def change do
    create table(:cards) do
      add :question, :string
      add :answer, :string
      add :last_answered_at, :time
      add :due_at, :time
      add :category_id, references(:categories)
      add :user_id, references(:users)

      timestamps()
    end

  end
end
