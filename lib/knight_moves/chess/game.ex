defmodule KnightMoves.Chess.Game do
  @moduledoc """
  The Chess Game.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @default_fen "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"

  schema "games" do
    field :fen, :string
    field :name, :string

    timestamps()
  end

  @doc false
  @spec changeset(%__MODULE__{}, map()) :: Changeset.t()
  def changeset(game, attrs) do
    game
    |> cast(attrs, [:fen, :name])
    |> validate_required([:fen])
  end

  @spec default_attrs() :: %{fen: String.t()}
  def default_attrs do
    %{fen: @default_fen}
  end
end
