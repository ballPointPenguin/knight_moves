defmodule KnightMovesWeb.GameLive.FormComponent do
  @moduledoc """
  Form to create/edit a Game.
  """

  use KnightMovesWeb, :live_component

  alias KnightMoves.Chess

  @impl Phoenix.LiveComponent
  def update(%{game: game} = assigns, socket) do
    changeset = Chess.change_game(game)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl Phoenix.LiveComponent
  def handle_event("validate", %{"game" => game_params}, socket) do
    changeset =
      socket.assigns.game
      |> Chess.change_game(game_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  @impl Phoenix.LiveComponent
  def handle_event("save", %{"game" => game_params}, socket) do
    save_game(socket, socket.assigns.action, game_params)
  end

  defp save_game(socket, :edit, game_params) do
    case Chess.update_game(socket.assigns.game, game_params) do
      {:ok, _game} ->
        {:noreply,
         socket
         |> put_flash(:info, "Game updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_game(socket, :new, game_params) do
    case Chess.create_game(game_params) do
      {:ok, _game} ->
        {:noreply,
         socket
         |> put_flash(:info, "Game created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
