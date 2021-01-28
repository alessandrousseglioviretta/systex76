defmodule Systex76.Github.Repository do
  use Ecto.Schema
  import Ecto.Changeset
  alias Systex76.Github.Stargazer

  schema "repositories" do
    field :name, :string
    field :org, :string
    many_to_many(:stargazers, Stargazer, join_through: "repository_stargazers")

    timestamps()
  end

  @doc false
  def changeset(repository, attrs \\ %{}) do
    repository
    |> cast(attrs, [:org, :name])
    |> validate_required([:org, :name])
    |> unique_constraint(:org, name: :repositories_unique_index)
  end
end
