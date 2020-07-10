defmodule DemoWeb.UserLive.Show do
  use Phoenix.LiveView
  use Phoenix.HTML

  alias DemoWeb.UserLive
  alias DemoWeb.Router.Helpers, as: Routes
  alias Demo.Accounts
  alias Phoenix.LiveView.Socket

  def render(assigns) do
    ~L"""
    <h2>Show User</h2>
    <ul>
      <li><b>Username:</b> <%= @user.username %></li>
      <li><b>Email:</b> <%= @user.email %></li>
      <li><b>Phone:</b> <%= @user.phone_number %></li>
    </ul>
    <span><%= link "Edit", to: Routes.live_path(@socket, UserLive.Edit, @user) %></span>
    <span><%= link "Back", to: Routes.live_path(@socket, DemoWeb.UserLive.PresenceIndex, 1) %></span>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"id" => id}, _url, socket) do
    if connected?(socket), do: Demo.Accounts.subscribe(id)
    {:noreply, socket |> assign(id: id) |> fetch()}
  end

  defp fetch(%Socket{assigns: %{id: id}} = socket) do
    case Accounts.get_user(id) do
      nil ->  redirect(socket, to: Routes.live_path(socket, UserLive.PresenceIndex, 1))
      user -> assign(socket, user: user)
    end
  end

  def handle_info({Accounts, [:user, :updated], _}, socket) do
    {:noreply, fetch(socket)}
  end

  def handle_info({Accounts, [:user, :deleted], _}, socket) do
    {:stop,
     socket
     |> put_flash(:error, "This user has been deleted from the system")
     |> redirect(to: Routes.live_path(socket, UserLive.Index))}
  end
end
