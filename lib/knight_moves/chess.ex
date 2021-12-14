defmodule KnightMoves.Chess do
  @moduledoc """
  The Chess context.
  """

  import Ecto.Query, warn: false
  alias KnightMoves.Repo

  alias KnightMoves.Chess.Board
  alias KnightMoves.Chess.Game

  @doc """
  Returns the list of games.

  ## Examples

      iex> list_games()
      [%Game{}, ...]

  """
  def list_games do
    Repo.all(Game)
  end

  @doc """
  Gets a single game.

  Raises `Ecto.NoResultsError` if the Game does not exist.

  ## Examples

      iex> get_game!(123)
      %Game{}

      iex> get_game!(456)
      ** (Ecto.NoResultsError)

  """
  def get_game!(id), do: Repo.get!(Game, id)

  @doc """
  Returns a default unsaved game.

  ## Examples

      iex> new_game(%{field: value})
      {:ok, %Game{
        fen: "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1",
        field: value
      }}

  """
  def new_game(attrs \\ %{}) do
    %Game{}
    |> Map.merge(Game.default_attrs())
    |> Map.merge(attrs)
  end

  @doc """
  Creates a game.

  ## Examples

      iex> create_game(%{field: value})
      {:ok, %Game{}}

      iex> create_game(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_game(attrs \\ %{}) do
    %Game{}
    |> Game.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a game.

  ## Examples

      iex> update_game(game, %{field: new_value})
      {:ok, %Game{}}

      iex> update_game(game, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_game(%Game{} = game, attrs) do
    game
    |> Game.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a game.

  ## Examples

      iex> delete_game(game)
      {:ok, %Game{}}

      iex> delete_game(game)
      {:error, %Ecto.Changeset{}}

  """
  def delete_game(%Game{} = game) do
    Repo.delete(game)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking game changes.

  ## Examples

      iex> change_game(game)
      %Ecto.Changeset{data: %Game{}}

  """
  def change_game(%Game{} = game, attrs \\ %{}) do
    Game.changeset(game, attrs)
  end

  @doc """
  Given a Game instance, returns a Board struct.

  ## Examples

      iex> game_board(game)
      %Board{}
  """
  def game_board(%{fen: fen}) do
    %Board{}
    |> Board.import_fen(fen)
    |> Board.assemble()
  end

  def game_board(_game) do
    %Board{}
  end

  def start_bb_server do
    :binbo.new_server()
  end

  def start_game(bb_pid, %Game{fen: fen}) do
    :binbo.new_game(bb_pid, fen)
  end

  def refresh_game_state(bb_pid, game) do
    {:ok, fen} = :binbo.get_fen(bb_pid)
    update_game(game, %{fen: fen})
  end

  def submit_move(bb_pid, move) do
    :binbo.move(bb_pid, move)
  end
end
