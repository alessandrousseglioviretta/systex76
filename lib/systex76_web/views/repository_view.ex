defmodule Systex76Web.RepositoryView do
  use Systex76Web, :view
  alias Systex76Web.RepositoryView

  def render("index.json", %{repositories: repositories}) do
    %{data: render_many(repositories, RepositoryView, "repository.json")}
  end

  def render("show.json", %{repository: repository}) do
    %{data: render_one(repository, RepositoryView, "repository.json")}
  end

  def render("repository.json", %{repository: repository}) do
    %{id: repository.id,
      org: repository.org,
      name: repository.name}
  end
end
