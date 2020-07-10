defmodule DemoWeb.CounterLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <div>
      <h1>The count is: <%= @val %></h1>
      <button phx-click="dec">-</button>
      <button phx-click="inc">+</button>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, val: 0)}
  end

  def handle_event("inc", _, socket) do
    {:noreply, update(socket, :val, fn val -> val + 1 end)}
  end

  def handle_event("dec", _, socket) do
    {:noreply, update(socket, :val, fn val -> val - 1 end)}
  end
end
