defmodule KnightMovesWeb.Square do
  use Phoenix.Component

  def render(%{pos: {row, col}} = assigns) do
    ~H"""
    <div class="square" data-square-row={row} data-square-col={col}>
      <span>
        <%= if @src do %>
          <img src={@src}>
        <% end %>
      </span>
    </div>
    """
  end
end
