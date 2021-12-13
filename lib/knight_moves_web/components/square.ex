defmodule KnightMovesWeb.Square do
  use Phoenix.Component

  def render(assigns) do
    ~H"""
    <div class={if @shade == :dsq, do: "bg-sky-600"} phx-click="square_click"
      phx-value-row={@row} phx-value-col={@col} phx-value-piece={@piece}>
      <span>
        <%= if @src do %>
          <img src={@src}>
        <% end %>
      </span>
    </div>
    """
  end
end
