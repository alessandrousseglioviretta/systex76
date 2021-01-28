defmodule Systex76.Github do
  @moduledoc """
  The Github context.
  """

  import Ecto.Query, warn: false
  alias Systex76.Repo
  alias Systex76.Github.{Repository, Stargazer}

  def add_repository_stargazer(stargazer = %Stargazer{}, repository = %Repository{}) do
    repository = repository |> Repo.preload(:stargazers)

    repository
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:stargazers, repository.stargazers ++ [stargazer])
    |> Repository.changeset()
    |> Repo.update!()

    stargazer
  end

  def timestamp_stargazing(stargazer = %Stargazer{}, repository = %Repository{}, day) do
    "
    UPDATE
      repository_stargazers
    SET
      inserted_on = $1
    WHERE
      inserted_on IS NULL
      AND stargazer_id=$2
      AND repository_id=$3;
    " |> Repo.query!([day, stargazer.id, repository.id])
  end

  @doc """
  Returns the list of repositories.

  ## Examples

      iex> list_repositories()
      [%Repository{}, ...]

  """
  def list_repositories do
    Repo.all(Repository)
  end

  @doc """
  Gets a single repository.

  Raises `Ecto.NoResultsError` if the Repository does not exist.

  ## Examples

      iex> get_repository!(123)
      %Repository{}

      iex> get_repository!(456)
      ** (Ecto.NoResultsError)

  """
  def get_repository!(id), do: Repo.get!(Repository, id)

  @doc """
  Creates a repository.

  ## Examples

      iex> create_repository(%{field: value})
      {:ok, %Repository{}}

      iex> create_repository(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_repository(attrs \\ %{}) do
    %Repository{}
    |> Repository.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a repository.

  ## Examples

      iex> update_repository(repository, %{field: new_value})
      {:ok, %Repository{}}

      iex> update_repository(repository, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_repository(%Repository{} = repository, attrs) do
    repository
    |> Repository.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a repository.

  ## Examples

      iex> delete_repository(repository)
      {:ok, %Repository{}}

      iex> delete_repository(repository)
      {:error, %Ecto.Changeset{}}

  """
  def delete_repository(%Repository{} = repository) do
    Repo.delete(repository)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking repository changes.

  ## Examples

      iex> change_repository(repository)
      %Ecto.Changeset{data: %Repository{}}

  """
  def change_repository(%Repository{} = repository, attrs \\ %{}) do
    Repository.changeset(repository, attrs)
  end

  alias Systex76.Github.Stargazer

  @doc """
  Returns the list of stargazers.

  ## Examples

      iex> list_stargazers()
      [%Stargazer{}, ...]

  """
  def list_stargazers do
    Repo.all(Stargazer)
  end

  def select_stargazers(opts \\ %{}) do
    {repository_id, _} = Map.fetch!(opts, "repository_id") |> Integer.parse()

    from_day = Map.get(opts, "from_day", "")

    to_day = Map.get(opts, "to_day", "")

    limit =
      case Map.get(opts, "limit", "30") |> Integer.parse() do
        :error -> ""
        {x, _} -> x
      end

    offset =
      case Map.get(opts, "offset", "0") |> Integer.parse() do
        :error -> ""
        {x, _} -> x
      end

    "
  SELECT
    *
  FROM
    stargazers
  WHERE
    id in(
      SELECT
        stargazer_id FROM repository_stargazers
      WHERE
        repository_id = $1
        AND ($2 = '' OR inserted_on >= to_date($2, 'YYYY-MM-DD'))
        AND ($3 = '' OR inserted_on <= to_date($3, 'YYYY-MM-DD'))
      LIMIT
        $4
      OFFSET
        $5);
  "
    |> Repo.query!([repository_id, from_day, to_day, limit, offset])
    |> Map.fetch!(:rows)
    |> Enum.map(fn x ->
      [id, _, stargazer, _, _] = x
      %{id: id, data: stargazer}
    end)
  end

  @doc """
  Gets a single stargazer.

  Raises `Ecto.NoResultsError` if the Stargazer does not exist.

  ## Examples

      iex> get_stargazer!(123)
      %Stargazer{}

      iex> get_stargazer!(456)
      ** (Ecto.NoResultsError)

  """
  def get_stargazer!(id), do: Repo.get!(Stargazer, id)

  @doc """
  Creates a stargazer.

  ## Examples

      iex> create_stargazer(%{field: value})
      {:ok, %Stargazer{}}

      iex> create_stargazer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_stargazer(attrs \\ %{}) do
    %Stargazer{}
    |> Stargazer.changeset(attrs)
    |> Repo.insert()
  end

  def get_or_create_stargazer(attrs \\ %{}) do
    case %Stargazer{}
         |> Stargazer.changeset(attrs)
         |> Repo.insert() do
      {:error, _} -> Stargazer |> Repo.get_by!(github_id: attrs.github_id)
      {:ok, stargazer} -> stargazer
    end
  end

  @doc """
  Updates a stargazer.

  ## Examples

      iex> update_stargazer(stargazer, %{field: new_value})
      {:ok, %Stargazer{}}

      iex> update_stargazer(stargazer, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_stargazer(%Stargazer{} = stargazer, attrs) do
    stargazer
    |> Stargazer.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a stargazer.

  ## Examples

      iex> delete_stargazer(stargazer)
      {:ok, %Stargazer{}}

      iex> delete_stargazer(stargazer)
      {:error, %Ecto.Changeset{}}

  """
  def delete_stargazer(%Stargazer{} = stargazer) do
    Repo.delete(stargazer)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking stargazer changes.

  ## Examples

      iex> change_stargazer(stargazer)
      %Ecto.Changeset{data: %Stargazer{}}

  """
  def change_stargazer(%Stargazer{} = stargazer, attrs \\ %{}) do
    Stargazer.changeset(stargazer, attrs)
  end

  def keys_to_atoms(string_key_map) when is_map(string_key_map) do
    for {key, val} <- string_key_map, into: %{}, do: {String.to_atom(key), keys_to_atoms(val)}
  end

  def keys_to_atoms(map_list) when is_list(map_list) do
    map_list |> Enum.map(fn x -> keys_to_atoms(x) end)
  end

  def keys_to_atoms(value), do: value
end
