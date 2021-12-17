defmodule KnightMovesWeb.PersonLive.Index do
  @moduledoc """
  Web Index of People.
  """

  use KnightMovesWeb, :live_view

  alias KnightMoves.Accounts
  alias KnightMoves.Accounts.Person

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :people, list_people())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Person")
    |> assign(:person, Accounts.get_person!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Person")
    |> assign(:person, %Person{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing People")
    |> assign(:person, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    person = Accounts.get_person!(id)
    {:ok, _} = Accounts.delete_person(person)

    {:noreply, assign(socket, :people, list_people())}
  end

  defp list_people do
    Accounts.list_people()
  end
end
