defmodule Systex76Web.PageController do
  use Systex76Web, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
