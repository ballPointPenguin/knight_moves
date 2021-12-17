defmodule KnightMoves.Accounts.Person do
  @moduledoc """
  The Accounts Person.
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "people" do
    field :email, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(person, attrs) do
    person
    |> cast(attrs, [:name, :email])
    |> validate_required([:name, :email])
  end
end
