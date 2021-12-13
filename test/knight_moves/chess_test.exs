defmodule KnightMoves.ChessTest do
  use KnightMoves.DataCase

  alias KnightMoves.Chess

  describe "games" do
    alias KnightMoves.Chess.Game

    import KnightMoves.ChessFixtures

    @invalid_attrs %{fen: nil}

    test "list_games/0 returns all games" do
      game = game_fixture()
      assert Chess.list_games() == [game]
    end

    test "get_game!/1 returns the game with given id" do
      game = game_fixture()
      assert Chess.get_game!(game.id) == game
    end

    test "create_game/1 with valid data creates a game" do
      valid_attrs = %{fen: "some fen"}

      assert {:ok, %Game{} = game} = Chess.create_game(valid_attrs)
      assert game.fen == "some fen"
    end

    test "create_game/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Chess.create_game(@invalid_attrs)
    end

    test "update_game/2 with valid data updates the game" do
      game = game_fixture()
      update_attrs = %{fen: "some updated fen"}

      assert {:ok, %Game{} = game} = Chess.update_game(game, update_attrs)
      assert game.fen == "some updated fen"
    end

    test "update_game/2 with invalid data returns error changeset" do
      game = game_fixture()
      assert {:error, %Ecto.Changeset{}} = Chess.update_game(game, @invalid_attrs)
      assert game == Chess.get_game!(game.id)
    end

    test "delete_game/1 deletes the game" do
      game = game_fixture()
      assert {:ok, %Game{}} = Chess.delete_game(game)
      assert_raise Ecto.NoResultsError, fn -> Chess.get_game!(game.id) end
    end

    test "change_game/1 returns a game changeset" do
      game = game_fixture()
      assert %Ecto.Changeset{} = Chess.change_game(game)
    end
  end
end
