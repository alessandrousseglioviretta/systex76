defmodule Systex76Web.StargazerControllerTest do
  use Systex76Web.ConnCase

  alias Systex76.Github
  alias Systex76.Github.Stargazer

  @create_attrs %{
    data: %{},
    github_id: 42
  }
  @update_attrs %{
    data: %{},
    github_id: 43
  }
  @invalid_attrs %{data: nil, github_id: nil}

  def fixture(:stargazer) do
    {:ok, stargazer} = Github.create_stargazer(@create_attrs)
    stargazer
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all stargazers", %{conn: conn} do
      conn = get(conn, Routes.stargazer_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create stargazer" do
    test "renders stargazer when data is valid", %{conn: conn} do
      conn = post(conn, Routes.stargazer_path(conn, :create), stargazer: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.stargazer_path(conn, :show, id))

      assert %{
               "id" => id,
               "data" => %{},
               "github_id" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.stargazer_path(conn, :create), stargazer: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update stargazer" do
    setup [:create_stargazer]

    test "renders stargazer when data is valid", %{conn: conn, stargazer: %Stargazer{id: id} = stargazer} do
      conn = put(conn, Routes.stargazer_path(conn, :update, stargazer), stargazer: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.stargazer_path(conn, :show, id))

      assert %{
               "id" => id,
               "data" => %{},
               "github_id" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, stargazer: stargazer} do
      conn = put(conn, Routes.stargazer_path(conn, :update, stargazer), stargazer: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete stargazer" do
    setup [:create_stargazer]

    test "deletes chosen stargazer", %{conn: conn, stargazer: stargazer} do
      conn = delete(conn, Routes.stargazer_path(conn, :delete, stargazer))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.stargazer_path(conn, :show, stargazer))
      end
    end
  end

  defp create_stargazer(_) do
    stargazer = fixture(:stargazer)
    %{stargazer: stargazer}
  end
end
