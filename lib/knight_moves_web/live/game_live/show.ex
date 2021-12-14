defmodule KnightMovesWeb.GameLive.Show do
  use KnightMovesWeb, :live_view

  alias KnightMoves.Chess

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    %{live_action: live_action} = socket.assigns
    game = Chess.get_game!(id)

    {:noreply,
     socket
     |> assign(:page_title, page_title(live_action))
     |> setup_board(game, live_action)}
  end

  @impl true
  def handle_event("square_click", square, socket) do
    %{player_to_move: player_to_move} = socket.assigns
    IO.inspect(player_to_move, label: "player_to_move")

    if player_to_move do
      select_square(socket, square)
    end
  end

  defp page_title(:show), do: "Show Game"
  defp page_title(:edit), do: "Edit Game"
  defp page_title(:play), do: "Play Game"

  defp setup_board(socket, game, :play) do
    # TODO - Share the server; handle problems
    {:ok, bb_pid} = Chess.start_bb_server()
    {:ok, :continue} = Chess.start_game(bb_pid, game)

    socket
    |> initialize_board(game, :play)
    |> assign(:bb_pid, bb_pid)
    |> assign(:selected_square, nil)
  end

  defp setup_board(socket, game, live_action) do
    initialize_board(socket, game, live_action)
  end

  defp initialize_board(socket, game, live_action) do
    socket
     |> assign(:board, Chess.game_board(game))
     |> assign(:game, game)
     |> assign(:player_to_move, player_to_move(game, live_action))
  end

  defp select_square(socket, square) do
    %{"col" => col, "piece" => piece, "row" => row} = square
    %{selected_square: selected_square} = socket.assigns

    case selected_square do
      nil ->
        if piece == "0" do
          {:noreply, socket}
        else
          {:noreply, assign(socket, :selected_square, "#{col}#{row}")}
        end

      _ ->
        new_move = {selected_square, "#{col}#{row}"}
        {:noreply, submit_move(socket, new_move)}
    end
  end

  defp submit_move(socket, {m1, m2}) do
    %{bb_pid: bb_pid} = socket.assigns
    move = m1 <> m2
    response = Chess.submit_move(bb_pid, move)

    case response do
      {:ok, :continue} ->
        socket
        |> assign(:selected_square, nil)
        |> update_game()

      {:ok, _status} ->
        # TODO handle checkmate or draw or whatever
        socket
        |> assign(:selected_square, nil)

      _ ->
        # TODO handle error or anything else
        socket
        |> assign(:selected_square, nil)
    end
  end

  defp update_game(socket) do
    %{bb_pid: bb_pid, game: game} = socket.assigns

    {:ok, game} = Chess.refresh_game_state(bb_pid, game)
    # TODO - also update game state and status

    socket
    |> assign(:game, game)
    |> assign(:board, Chess.game_board(game))
  end

  defp player_to_move(_game, live_action) do
    # TODO check if it is the user's turn, the game is not completed,
    # and the turn is current
    live_action == :play
  end
end
