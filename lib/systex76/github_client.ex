defmodule Systex76.GithubClient do
  use Tesla
  alias Systex76.Github.Repository

  plug Tesla.Middleware.BaseUrl, "https://api.github.com"

  plug Tesla.Middleware.Headers, [
    {"user-agent", Application.get_env(:systex76, :github)[:username]}
  ]

  plug Tesla.Middleware.BasicAuth,
    username: Application.get_env(:systex76, :github)[:username],
    password: Application.get_env(:systex76, :github)[:personal_access_token]

  plug Tesla.Middleware.JSON

  def get_stargazers(repository = %Repository{}, page, per_page) do
    get_stargazers(repository.org, repository.name, page, per_page)
  end

  def get_stargazers(org, name, page, per_page) when is_binary(org) do
    {:ok, %Tesla.Env{body: body}} =
      get("repos/#{org}/#{name}/stargazers?page=#{page}&per_page=#{per_page}")

    body
  end
end
