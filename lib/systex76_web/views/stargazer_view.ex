defmodule Systex76Web.StargazerView do
  use Systex76Web, :view
  alias Systex76Web.StargazerView

  def render("index.json", %{stargazers: stargazers}) do
    %{data: render_many(stargazers, StargazerView, "stargazer.json")}
  end

  def render("show.json", %{stargazer: stargazer}) do
    %{data: render_one(stargazer, StargazerView, "stargazer.json")}
  end

  def render("stargazer.json", %{stargazer: stargazer}) do
    %{id: stargazer.id, data: stargazer.data}
  end
end
