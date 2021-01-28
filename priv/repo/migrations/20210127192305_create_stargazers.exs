defmodule Systex76.Repo.Migrations.CreateStargazers do
  use Ecto.Migration

  def change do
    create table(:stargazers) do
      add :github_id, :bigint
      add :data, :map

      timestamps()
    end

    create(unique_index(:stargazers, [:github_id], name: :stargazers_unique_index))
  end
end
