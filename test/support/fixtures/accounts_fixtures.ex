defmodule KnightMoves.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `KnightMoves.Accounts` context.
  """

  @doc """
  Generate a person.
  """
  def person_fixture(attrs \\ %{}) do
    {:ok, person} =
      attrs
      |> Enum.into(%{
        email: "some email",
        name: "some name"
      })
      |> KnightMoves.Accounts.create_person()

    person
  end
end
