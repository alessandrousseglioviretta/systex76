defmodule Systex76Web.RepositoryController do
  use Systex76Web, :controller

  alias Systex76.Github
  alias Systex76.Github.Repository

  action_fallback Systex76Web.FallbackController

  def index(conn, _params) do
    repositories = Github.list_repositories()
    render(conn, "index.json", repositories: repositories)
  end

  def create(conn, %{"repository" => repository_params}) do
    with {:ok, %Repository{} = repository} <- Github.create_repository(repository_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.repository_path(conn, :show, repository))
      |> render("show.json", repository: repository)
    end
  end

  def show(conn, %{"id" => id}) do
    repository = Github.get_repository!(id)
    render(conn, "show.json", repository: repository)
  end

  def update(conn, %{"id" => id, "repository" => repository_params}) do
    repository = Github.get_repository!(id)

    with {:ok, %Repository{} = repository} <-
           Github.update_repository(repository, repository_params) do
      render(conn, "show.json", repository: repository)
    end
  end

  def delete(conn, %{"id" => id}) do
    repository = Github.get_repository!(id)

    with {:ok, %Repository{}} <- Github.delete_repository(repository) do
      send_resp(conn, :no_content, "")
    end
  end
end
