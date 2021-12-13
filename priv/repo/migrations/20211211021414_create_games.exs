defmodule KnightMoves.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :fen, :string
      add :name, :string

      timestamps()
    end
  end
end
