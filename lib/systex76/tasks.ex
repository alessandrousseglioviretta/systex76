defmodule Systex76.Tasks do
  alias Systex76.{Github, GithubClient}
  alias __MODULE__

  defmodule ReachTheStars do
    use Oban.Worker, queue: :github

    @impl Oban.Worker
    def perform(job) do
      %{"id" => id} = job.args
      repository = Github.get_repository!(id)
      Tasks.retrieve_stargazers(repository, 1)
      :ok
    end
  end

  defmodule RetrieveStargazers do
    use Oban.Worker, queue: :github

    @impl Oban.Worker
    def perform(_job) do
      Tasks.retrieve_all_stargazers()
      :ok
    end
  end

  def retrieve_stargazers(repository, page) do
    per_page = Application.get_env(:system76, :github, :per_page)

    case GithubClient.get_stargazers(repository, page, per_page) do
      [] ->
        IO.puts("done")
        :ok

      list ->
        today = Date.utc_today()
        page_count = length(list)

        list
        |> Enum.with_index()
        |> Enum.each(fn {stargazer, index} ->
          ProgressBar.render(index + 1, page_count)

          %{github_id: stargazer["id"], data: stargazer}
          |> Github.get_or_create_stargazer()
          |> Github.add_repository_stargazer(repository)
          |> Github.timestamp_stargazing(repository, today)
        end)

        retrieve_stargazers(repository, page + 1)
    end
  end

  def retrieve_all_stargazers() do
    IO.puts("scheduling and running jobs, hold tight")

    Github.list_repositories()
    |> Enum.each(fn repository ->
      repository
      |> Map.from_struct()
      |> Map.take([:id])
      |> ReachTheStars.new()
      |> Oban.insert()
    end)
  end
end
