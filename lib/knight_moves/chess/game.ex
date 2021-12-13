defmodule KnightMoves.Chess.Game do
  use Ecto.Schema
  import Ecto.Changeset

  @default_fen "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"

  schema "games" do
    field :fen, :string

    timestamps()
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [:fen])
    |> validate_required([:fen])
  end

  def default_attrs do
    %{fen: @default_fen}
  end
end
