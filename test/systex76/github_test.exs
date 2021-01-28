defmodule Systex76.GithubTest do
  use Systex76.DataCase

  alias Systex76.Github

  describe "repositories" do
    alias Systex76.Github.Repository

    @valid_attrs %{name: "some name", org: "some org"}
    @update_attrs %{name: "some updated name", org: "some updated org"}
    @invalid_attrs %{name: nil, org: nil}

    def repository_fixture(attrs \\ %{}) do
      {:ok, repository} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Github.create_repository()

      repository
    end

    test "list_repositories/0 returns all repositories" do
      repository = repository_fixture()
      assert Github.list_repositories() == [repository]
    end

    test "get_repository!/1 returns the repository with given id" do
      repository = repository_fixture()
      assert Github.get_repository!(repository.id) == repository
    end

    test "create_repository/1 with valid data creates a repository" do
      assert {:ok, %Repository{} = repository} = Github.create_repository(@valid_attrs)
      assert repository.name == "some name"
      assert repository.org == "some org"
    end

    test "create_repository/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Github.create_repository(@invalid_attrs)
    end

    test "update_repository/2 with valid data updates the repository" do
      repository = repository_fixture()
      assert {:ok, %Repository{} = repository} = Github.update_repository(repository, @update_attrs)
      assert repository.name == "some updated name"
      assert repository.org == "some updated org"
    end

    test "update_repository/2 with invalid data returns error changeset" do
      repository = repository_fixture()
      assert {:error, %Ecto.Changeset{}} = Github.update_repository(repository, @invalid_attrs)
      assert repository == Github.get_repository!(repository.id)
    end

    test "delete_repository/1 deletes the repository" do
      repository = repository_fixture()
      assert {:ok, %Repository{}} = Github.delete_repository(repository)
      assert_raise Ecto.NoResultsError, fn -> Github.get_repository!(repository.id) end
    end

    test "change_repository/1 returns a repository changeset" do
      repository = repository_fixture()
      assert %Ecto.Changeset{} = Github.change_repository(repository)
    end
  end

  describe "stargazers" do
    alias Systex76.Github.Stargazer

    @valid_attrs %{data: %{}, github_id: 42, last_seen_at: ~N[2010-04-17 14:00:00]}
    @update_attrs %{data: %{}, github_id: 43, last_seen_at: ~N[2011-05-18 15:01:01]}
    @invalid_attrs %{data: nil, github_id: nil, last_seen_at: nil}

    def stargazer_fixture(attrs \\ %{}) do
      {:ok, stargazer} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Github.create_stargazer()

      stargazer
    end

    test "list_stargazers/0 returns all stargazers" do
      stargazer = stargazer_fixture()
      assert Github.list_stargazers() == [stargazer]
    end

    test "get_stargazer!/1 returns the stargazer with given id" do
      stargazer = stargazer_fixture()
      assert Github.get_stargazer!(stargazer.id) == stargazer
    end

    test "create_stargazer/1 with valid data creates a stargazer" do
      assert {:ok, %Stargazer{} = stargazer} = Github.create_stargazer(@valid_attrs)
      assert stargazer.data == %{}
      assert stargazer.github_id == 42
      assert stargazer.last_seen_at == ~N[2010-04-17 14:00:00]
    end

    test "create_stargazer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Github.create_stargazer(@invalid_attrs)
    end

    test "update_stargazer/2 with valid data updates the stargazer" do
      stargazer = stargazer_fixture()
      assert {:ok, %Stargazer{} = stargazer} = Github.update_stargazer(stargazer, @update_attrs)
      assert stargazer.data == %{}
      assert stargazer.github_id == 43
      assert stargazer.last_seen_at == ~N[2011-05-18 15:01:01]
    end

    test "update_stargazer/2 with invalid data returns error changeset" do
      stargazer = stargazer_fixture()
      assert {:error, %Ecto.Changeset{}} = Github.update_stargazer(stargazer, @invalid_attrs)
      assert stargazer == Github.get_stargazer!(stargazer.id)
    end

    test "delete_stargazer/1 deletes the stargazer" do
      stargazer = stargazer_fixture()
      assert {:ok, %Stargazer{}} = Github.delete_stargazer(stargazer)
      assert_raise Ecto.NoResultsError, fn -> Github.get_stargazer!(stargazer.id) end
    end

    test "change_stargazer/1 returns a stargazer changeset" do
      stargazer = stargazer_fixture()
      assert %Ecto.Changeset{} = Github.change_stargazer(stargazer)
    end
  end
end
