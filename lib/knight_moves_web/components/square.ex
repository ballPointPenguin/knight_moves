defmodule KnightMovesWeb.Square do
  use Phoenix.Component

  use Phoenix.HTML

  def render(%{pos: {row, col}} = assigns) do
    piece = assigns[:piece] || "#{col}#{row}"

    ~H"""
    <div class="square" data-square-row={row} data-square-col={col}>
      <span><%= raw piece %></span>
    </div>
    """
  end
end
