defmodule Systex76.Repo.Migrations.CreateRepoStargazers do
  use Ecto.Migration

  def change do
    create table(:repository_stargazers, primary_key: false) do
      add(:repository_id, references(:repositories))
      add(:stargazer_id, references(:stargazers))
      add(:inserted_on, :date)
    end

    create(unique_index(:repository_stargazers, [:repository_id, :stargazer_id]))
  end
end
