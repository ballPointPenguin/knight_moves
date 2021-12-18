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
  @spec list_games() :: [Game.t()] | []
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
  @spec get_game!(String.t()) :: Game.t() | Ecto.NoResultsError.t()
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
  @spec new_game(map()) :: Game.t()
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
  @spec create_game(map()) :: {:ok, Game.t()} | {:error, Ecto.Changeset.t()}
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
  @spec update_game(Game.t(), map()) :: {:ok, Game.t()} | {:error, Ecto.Changeset.t()}
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
  @spec delete_game(Game.t()) :: {:ok, Game.t()} | {:error, Ecto.Changeset.t()}
  def delete_game(%Game{} = game) do
    Repo.delete(game)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking game changes.

  ## Examples

      iex> change_game(game)
      %Ecto.Changeset{data: %Game{}}

  """
  @spec change_game(Game.t(), map()) :: {:ok, Game.t()} | {:error, Ecto.Changeset.t()}
  def change_game(%Game{} = game, attrs \\ %{}) do
    Game.changeset(game, attrs)
  end

  @doc """
  Given a Game instance, returns a Board struct.

  ## Examples

      iex> game_board(game)
      %Board{}
  """
  @spec game_board(%{fen: String.t()}) :: Board.t()
  def game_board(%{fen: fen}) do
    %Board{}
    |> Board.import_fen(fen)
    |> Board.assemble()
  end

  def game_board(_game) do
    %Board{}
  end

  @spec start_bb_server() :: {:ok, pid()} | {:error, any}
  def start_bb_server do
    :binbo.new_server()
  end

  @type game_status() ::
          :continue
          | {:checkmate, :white_wins | :black_wins}
          | {:draw,
             :stalemate
             | :rule50
             | :insufficient_material
             | :threefold_repetition
             | {:manual, any()}}
          | {:winner, any(), {:manual, any()}}

  @spec start_game(pid(), Game.t()) :: {:ok, game_status()} | {:error, any()}
  def start_game(bb_pid, %Game{fen: fen}) do
    :binbo.new_game(bb_pid, fen)
  end

  @spec refresh_game_state(pid(), Game.t()) ::
          {:ok, Game.t()} | {:error, Ecto.Changeset.t() | {:bad_game, any()}}
  def refresh_game_state(bb_pid, game) do
    case :binbo.get_fen(bb_pid) do
      {:ok, fen} ->
        update_game(game, %{fen: fen})

      {:error, {:bad_game, term}} ->
        {:error, {:bad_game, term}}
    end
  end

  @spec submit_move(pid(), String.t() | charlist()) ::
          {:ok, game_status()} | {:error, :binbo_game.move_error()}
  def submit_move(bb_pid, move) do
    :binbo.move(bb_pid, move)
  end
end
