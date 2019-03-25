# adds some useful functions to ecto models
defmodule Consolidate.Model do
  defmacro __using__(_) do
    quote do
      alias Consolidate.Repo
      def find(id), do: Repo.get(__MODULE__,id)

      def create(attrs \\ %{}) do
        %__MODULE__{}
        |> __MODULE__.changeset(attrs)
        |> Consolidate.Repo.insert()
      end

      def create!(attrs \\ %{}) do
        %__MODULE__{}
        |> __MODULE__.changeset(attrs)
        |> Consolidate.Repo.insert!()
      end
    end
  end
end
