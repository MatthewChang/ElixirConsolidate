defmodule Consolidate.Repo.Migrations.CreateCards do
  use Ecto.Migration

  def change do
    create table(:cards) do
      add :question, :text
      add :answer, :text
      add :last_answered_at, :utc_datetime
      add :due_at, :utc_datetime
      add :category_id, references(:categories)
      add :user_id, references(:users)

      timestamps()
    end
  end
end
