defmodule KnightMovesWeb.Square do
  use Phoenix.Component

  def render(assigns) do
    ~H"""
    <div class={if @shade == :dsq, do: "bg-sky-600"}
      data-square-row={@row} data-square-col={@col} data-square-piece={@piece}>
      <span>
        <%= if @src do %>
          <img src={@src}>
        <% end %>
      </span>
    </div>
    """
  end
end
