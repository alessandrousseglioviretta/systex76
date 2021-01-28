defmodule Systex76.Github.Stargazer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "stargazers" do
    field :data, :map
    field :github_id, :integer

    timestamps()
  end

  @doc false
  def changeset(stargazer, attrs) do
    stargazer
    |> cast(attrs, [:github_id, :data])
    |> validate_required([:github_id, :data])
    |> unique_constraint(:github_id, name: :stargazers_unique_index)
  end
end
