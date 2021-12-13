defmodule KnightMovesWeb.PageController do
  use KnightMovesWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
