defmodule KnightMovesWeb.GameLive.BoardComponent do
  use KnightMovesWeb, :live_component

  @rows [8,7,6,5,4,3,2,1]

  @cols [:a,:b,:c,:d,:e,:f,:g,:h]

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(:rows, @rows)
     |> assign(:cols, @cols)
     |> assign(assigns)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="board">
      <%= for row <- @rows, col <- @cols do %>
        <KnightMovesWeb.Square.render piece="&#9813;" pos={{row, col}} />
      <% end %>
    </div>
    """
  end
end
