defmodule KnightMovesWeb.GameLive.BoardComponent do
  use KnightMovesWeb, :live_component

  @piece_image_map [
    R: :rl, N: :nl, B: :bl, Q: :ql, K: :kl, P: :pl,
    r: :rd, n: :nd, b: :bd, q: :qd, k: :kd, p: :pd
  ]

  @impl true
  def update(assigns, socket) do
    %{board: %{tuples: tuples}} = assigns

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:tuples, tuples)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="board">
      <%= for {row, col, piece, shade} <- @tuples do %>
        <KnightMovesWeb.Square.render
          row={row} col={col} piece={piece} shade={shade} src={piece_svg_src(piece)} />
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
