defmodule Systex76.Repo.Migrations.CreateRepositories do
  use Ecto.Migration

  def change do
    create table(:repositories) do
      add :org, :string
      add :name, :string

      timestamps()
    end

    create(unique_index(:repositories, [:org, :name], name: :repositories_unique_index))
  end
end
