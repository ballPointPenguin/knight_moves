defmodule KnightMovesWeb.GameLive.Show do
  use KnightMovesWeb, :live_view

  alias KnightMoves.Chess

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    game = Chess.get_game!(id)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:board, Chess.game_board(game))
     |> assign(:game, game)}
  end

  @impl true
  def handle_event("square_click", _value, socket), do: {:noreply, socket}

  defp page_title(:show), do: "Show Game"
  defp page_title(:edit), do: "Edit Game"
end
