defmodule KnightMoves.Repo do
  use Ecto.Repo,
    otp_app: :knight_moves,
    adapter: Ecto.Adapters.Postgres
end
