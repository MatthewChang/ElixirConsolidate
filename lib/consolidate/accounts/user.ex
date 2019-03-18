defmodule Consolidate.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Comeonin.Bcrypt

  schema "users" do
    field :email, :string
    field :password, :string

    timestamps()
  end

  use Consolidate.Model

  @doc false
  def changeset(%Consolidate.Accounts.User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> put_password_hash()
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} -> 
        change(changeset, password: Bcrypt.hashpwsalt(password))
      _ -> changeset
    end
  end
end
