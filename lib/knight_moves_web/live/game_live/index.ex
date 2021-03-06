defmodule KnightMovesWeb.GameLive.Index do
  @moduledoc """
  Web Index of Games.
  """

  use KnightMovesWeb, :live_view

  alias KnightMoves.Chess

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :games, list_games())}
  end

  @impl Phoenix.LiveView
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl Phoenix.LiveView
  def handle_event("delete", %{"id" => id}, socket) do
    game = Chess.get_game!(id)
    {:ok, _game} = Chess.delete_game(game)

    {:noreply, assign(socket, :games, list_games())}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Game")
    |> assign(:game, Chess.get_game!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Game")
    |> assign(:game, Chess.new_game())
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Games")
    |> assign(:game, nil)
  end

  defp list_games do
    Chess.list_games()
  end
end
