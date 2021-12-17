defmodule KnightMoves.Chess.Square do
  @moduledoc """
  A Struct for handling a single chess board square with its attributes.
  """

  defstruct [:name, :col, :row, :piece, :shade, :status]
end
