defmodule KnightMoves.ChessFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `KnightMoves.Chess` context.
  """

  @doc """
  Generate a game.
  """
  def game_fixture(attrs \\ %{}) do
    {:ok, game} =
      attrs
      |> Enum.into(%{
        fen: "some fen"
      })
      |> KnightMoves.Chess.create_game()

    game
  end
end
