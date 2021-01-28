defmodule Systex76Web.StargazerController do
  use Systex76Web, :controller

  alias Systex76.Github
  alias Systex76.Github.Stargazer

  action_fallback Systex76Web.FallbackController

  def select(conn, params) do
    stargazers = Github.select_stargazers(params)
    render(conn, "index.json", stargazers: stargazers)
  end

  def index(conn, _params) do
    stargazers = Github.list_stargazers()
    render(conn, "index.json", stargazers: stargazers)
  end

  def create(conn, %{"stargazer" => stargazer_params}) do
    with {:ok, %Stargazer{} = stargazer} <- Github.create_stargazer(stargazer_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.stargazer_path(conn, :show, stargazer))
      |> render("show.json", stargazer: stargazer)
    end
  end

  def show(conn, %{"id" => id}) do
    stargazer = Github.get_stargazer!(id)
    render(conn, "show.json", stargazer: stargazer)
  end

  def update(conn, %{"id" => id, "stargazer" => stargazer_params}) do
    stargazer = Github.get_stargazer!(id)

    with {:ok, %Stargazer{} = stargazer} <- Github.update_stargazer(stargazer, stargazer_params) do
      render(conn, "show.json", stargazer: stargazer)
    end
  end

  def delete(conn, %{"id" => id}) do
    stargazer = Github.get_stargazer!(id)

    with {:ok, %Stargazer{}} <- Github.delete_stargazer(stargazer) do
      send_resp(conn, :no_content, "")
    end
  end
end
