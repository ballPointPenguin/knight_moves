defmodule KnightMoves.Chess.Board do
  @moduledoc """
  The Chess Board module.
  This is a representation of the board that is used to render and
  interact with it. It is not persisted in the database. It can be generated
  from a Game record and used while the application is running.
  """

  @cols [:a, :b, :c, :d, :e, :f, :g, :h]
  @pieces [:R, :N, :B, :Q, :K, :P, :r, :n, :b, :q, :k, :p]
  @rows [8, 7, 6, 5, 4, 3, 2, 1]
  @squares for row <- @rows, col <- @cols, do: {row, col}

  defstruct orientation: :default,
            matrix: [
              [0, 0, 0, 0, 0, 0, 0, 0],
              [0, 0, 0, 0, 0, 0, 0, 0],
              [0, 0, 0, 0, 0, 0, 0, 0],
              [0, 0, 0, 0, 0, 0, 0, 0],
              [0, 0, 0, 0, 0, 0, 0, 0],
              [0, 0, 0, 0, 0, 0, 0, 0],
              [0, 0, 0, 0, 0, 0, 0, 0],
              [0, 0, 0, 0, 0, 0, 0, 0]
            ],
            tuples: []

  @spec flip(%__MODULE__{}) :: %__MODULE__{}
  def flip(%__MODULE__{orientation: :default} = board) do
    Map.merge(board, %{orientation: :inverse})
  end

  def flip(%__MODULE__{orientation: :inverse} = board) do
    Map.merge(board, %{orientation: :default})
  end

  @spec import_fen(%__MODULE__{}, String.t()) :: %__MODULE__{}
  def import_fen(%__MODULE__{} = board, fen) do
    Map.merge(board, %{matrix: parse_fen(fen)})
  end

  @spec assemble(%__MODULE__{}) :: %__MODULE__{}
  def assemble(%__MODULE__{matrix: matrix} = board) do
    Map.merge(board, %{tuples: make_tuples(matrix)})
  end

  # @default_fen "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
  defp parse_fen(fen) do
    fen
    |> String.split()
    |> List.first()
    |> String.split("/")
    |> Enum.map(fn row -> fen_row_to_pieces(row) end)

    # [
    #   [:R, :N, :B, :Q, :K, :B, :N, :R],
    #   [:P, :P, :P, :P, :P, :P, :P, :P],
    #   [0,  0,  0,  0,  0,  0,  0,  0 ],
    #   [0,  0,  0,  0,  0,  0,  0,  0 ],
    #   [0,  0,  0,  0,  0,  0,  0,  0 ],
    #   [0,  0,  0,  0,  0,  0,  0,  0 ],
    #   [:p, :p, :p, :p, :p, :p, :p, :p],
    #   [:r, :n, :b, :q, :k, :b, :n, :r]
    # ]
  end

  defp fen_row_to_pieces("8") do
    [0, 0, 0, 0, 0, 0, 0, 0]
  end

  defp fen_row_to_pieces(row) do
    row
    |> String.split("", trim: true)
    |> Enum.map(fn char -> fen_char_to_piece(char) end)
    |> List.flatten()
  end

  defp fen_char_to_piece(char) do
    cond do
      String.match?(char, ~r/[0-9]/) ->
        spaces = String.to_integer(char)
        for _space <- 1..spaces, do: 0

      # Ensure the atoms exist before using String.to_existing_atom
      char in Enum.map(@pieces, &Atom.to_string/1) ->
        String.to_existing_atom(char)
    end
  end

  # {row, col, piece, shade}
  defp make_tuples(matrix) do
    flat_matrix = List.flatten(matrix)

    for i <- 0..63 do
      @squares
      |> Enum.at(i)
      |> Tuple.append(Enum.at(flat_matrix, i))
      |> Tuple.append(square_shade(i))
    end
  end

  @spec square_shade(non_neg_integer()) :: :light | :dark
  defp square_shade(index) do
    square_even_odd = Integer.mod(index, 2)
    row_even_odd = index |> Integer.floor_div(8) |> Integer.mod(2)

    # Counting down from row 7 to 0
    # E.g. A8 is square 0, row 7. even square, odd row. dark square.
    case square_even_odd == row_even_odd do
      true ->
        :light

      false ->
        :dark
    end
  end
end
