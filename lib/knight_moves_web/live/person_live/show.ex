defmodule KnightMovesWeb.PersonLive.Show do
  @moduledoc """
  Show a Person.
  """

  use KnightMovesWeb, :live_view

  alias KnightMoves.Accounts

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:person, Accounts.get_person!(id))}
  end

  defp page_title(:show), do: "Show Person"
  defp page_title(:edit), do: "Edit Person"
end
