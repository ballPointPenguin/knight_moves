defmodule KnightMoves.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :fen, :string

      timestamps()
    end
  end
end
