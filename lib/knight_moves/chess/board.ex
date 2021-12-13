defmodule KnightMoves.Chess.Board do
  @cols [:a,:b,:c,:d,:e,:f,:g,:h]
  @rows [8,7,6,5,4,3,2,1]
  @squares for row <- @rows, col <- @cols, do: {row, col}

  defstruct [
    orientation: :default,
    matrix: [
      [0,  0,  0,  0,  0,  0,  0,  0 ],
      [0,  0,  0,  0,  0,  0,  0,  0 ],
      [0,  0,  0,  0,  0,  0,  0,  0 ],
      [0,  0,  0,  0,  0,  0,  0,  0 ],
      [0,  0,  0,  0,  0,  0,  0,  0 ],
      [0,  0,  0,  0,  0,  0,  0,  0 ],
      [0,  0,  0,  0,  0,  0,  0,  0 ],
      [0,  0,  0,  0,  0,  0,  0,  0 ]
    ],
    tuples: []
  ]

  def flip(%__MODULE__{orientation: :default} = board) do
    Map.merge(board, %{orientation: :inverse})
  end

  def flip(%__MODULE__{orientation: :inverse} = board) do
    Map.merge(board, %{orientation: :default})
  end

  def import_fen(%__MODULE__{} = board, fen) do
    Map.merge(board, %{matrix: parse_fen(fen)})
  end

  def assemble(%__MODULE__{matrix: matrix} = board) do
    Map.merge(board, %{tuples: make_tuples(matrix)})
  end

  # @default_fen "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
  defp parse_fen(fen) do
    # parsed =
    fen
    |> String.split()
    |> List.first()
    |> String.split("/")
    |> Enum.reverse()
    |> Enum.map(fn row -> fen_row_to_pieces(row) end)

    # require IEx; IEx.pry

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
    [0, 0, 0, 0, 0,  0,  0,  0]
  end

  defp fen_row_to_pieces(row) do
    row
    |> String.split("", trim: true)
    |> Enum.map(fn char -> fen_char_to_piece(char) end)
    |> List.flatten()
  end

  defp fen_char_to_piece(char) do
    if String.match?(char, ~r/[0-9]/) do
      spaces = String.to_integer(char)
      for _ <- 1..spaces, do: 0
    else
      String.to_atom(char)
    end
  end

  # {row, col, piece, shade}
  defp make_tuples(matrix) do
    flat_matrix = List.flatten(matrix)

    for i <- 0..63 do
      Enum.at(@squares, i)
      |> Tuple.append(Enum.at(flat_matrix, i))
      |> Tuple.append(square_shade(i))
    end
  end

  # Determine if a given square integer is dark or white shaded
  defp square_shade(i) do
    case Integer.mod(i, 2) == Integer.floor_div(i, 8) |> Integer.mod(2) do
      true ->
        :lsq

      false ->
        :dsq
    end
  end
end
