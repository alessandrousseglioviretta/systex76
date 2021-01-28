# Systex76

## Installation

To use this app you need a [Github personal access token](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token)
otherwise Github will throttle your calls very soon.

Place your Github username and access token in the app config under `config :systex76, :github`.


To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `iex -S mix phx.server`. You'll need the REPL later on.

`mix phx.routes` displays all the available routes, only two of which are relevant for this exercise.

## Create a repo

To create a repository, use the following command:

```
curl --location --request POST 'http://localhost:5000/api/repositories' \
--header 'Content-Type: application/json' \
--data-raw '{
    "repository": {"name": "octocat.github.io", "org": "octocat"}
}'
```

Take note of the `id`, because you'll need it later to get the repo's stargazers.

```
{
    "data": {
        "id": 1,
        "name": "octocat.github.io",
        "org": "octocat"
    }
}
```

## Scheduled jobs for retrieving stargazers

Stargazers for all stored repos are retrieved at UTC midnigth by using a [scheduled task](https://github.com/sorentwo/oban#periodic-jobs).

The retrieval of a repo's stargazers uses a job queue to allow for retrials and throttling.

### Retrieving stargazers for the impatient

If you are in a hurry, get the stargazers for all stored repos, use the following command:

```
Systex76.Tasks.retrieve_all_stargazers()
```

## Get the stargazers

GET the stargazers for a repo at this URL: `http://localhost:5000/api/select-stargazers/:repository_id`
The `repository_id` is the id of the stored repo that you obtained when `POST`ing the repo in the previous step.

To filter the stargazers in time period 2021-01-26 to 2021-01-29, use the following command:

```
curl --location --request GET 'http://localhost:5000/api/select-stargazers/1?&from_day=2021-01-26&to_day=2021-01-29&limit=5&offset=5'
```

`from_day` and `to_day` are to be expressed in the `YYYY-MM-DD` format. `limit` and `offset` work as in a SQL query.

The dates correspond to the day the repo-stargazer relationship was stored, not the actual time when the repo was starred.

## Most interesting thing about this exercise
The many-to-many relationship modeled via the `repository_stargazers` table:

```many_to_many(:stargazers, Stargazer, join_through: "repository_stargazers")```