defmodule KnightMovesWeb.PersonLive.FormComponent do
  @moduledoc """
  The Create/Edit Person Form.
  """

  use KnightMovesWeb, :live_component

  alias KnightMoves.Accounts

  @impl true
  def update(%{person: person} = assigns, socket) do
    changeset = Accounts.change_person(person)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"person" => person_params}, socket) do
    changeset =
      socket.assigns.person
      |> Accounts.change_person(person_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"person" => person_params}, socket) do
    save_person(socket, socket.assigns.action, person_params)
  end

  defp save_person(socket, :edit, person_params) do
    case Accounts.update_person(socket.assigns.person, person_params) do
      {:ok, _person} ->
        {:noreply,
         socket
         |> put_flash(:info, "Person updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_person(socket, :new, person_params) do
    case Accounts.create_person(person_params) do
      {:ok, _person} ->
        {:noreply,
         socket
         |> put_flash(:info, "Person created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
