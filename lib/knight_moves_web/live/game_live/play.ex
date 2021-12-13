defmodule KnightMovesWeb.GameLive.Play do
  use KnightMovesWeb, :live_view

  alias KnightMoves.Chess

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :moves, [])}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    game = Chess.get_game!(id)
    # TODO get moves from PNG if exists
    moves = []
    selected_square = nil
    {:ok, bb_pid} = :binbo.new_server()
    {:ok, :continue} = :binbo.new_game(bb_pid, game.fen)

    {:noreply,
     socket
     |> assign(:board, Chess.game_board(game))
     |> assign(:game, game)
     |> assign(:bb_pid, bb_pid)
     |> assign(:moves, moves)
     |> assign(:selected_square, selected_square)}
  end

  @impl true
  def handle_event("square_click", square, socket) do
    select_square(socket, square)
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
    %{bb_pid: bb_pid, moves: moves} = socket.assigns
    move = m1 <> m2
    response = :binbo.move(bb_pid, move)

    case response do
      {:ok, :continue} ->
        socket
        |> assign(:selected_square, nil)
        |> assign(:moves, Enum.concat(moves, [{m1, m2}]))
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

    {:ok, fen} = :binbo.get_fen(bb_pid)
    {:ok, game} = Chess.update_game(game, %{fen: fen})
    # TODO - also update game state and status

    socket
    |> assign(:game, game)
    |> assign(:board, Chess.game_board(game))
  end
end
