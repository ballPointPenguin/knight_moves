defmodule KnightMovesWeb.GameLive.BoardComponent do
  use KnightMovesWeb, :live_component

  @piece_image_map [
    R: :rd, N: :nd, B: :bd, Q: :qd, K: :kd, P: :pd,
    r: :rl, n: :nl, b: :bl, q: :ql, k: :kl, p: :pl
  ]

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)}
  end

  @impl true
  def render(%{board: board} = assigns) do
    ~H"""
    <div class="board">
      <%= for {col, row, piece} <- board.tuples do %>
        <KnightMovesWeb.Square.render piece="&#9813;" pos={{row, col}} src={piece_svg_src(piece)} />
      <% end %>
    </div>
    """
  end

  defp piece_svg_src(0), do: nil

  defp piece_svg_src(piece) do
    case @piece_image_map[piece] do
      nil ->
        nil

      filename ->
        path = "/svg/#{filename}.svg"
        Routes.static_path(KnightMovesWeb.Endpoint, path)
    end
  end
end
