defmodule MessageStreamWeb.EmailLive.Index do
  use MessageStreamWeb, :live_view

  alias MessageStream.Emails
  alias MessageStream.Emails.Email

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(page: 1, per_page: 100, search: nil)
      |> paginate_emails(1)

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Email")
    |> assign(:email, Emails.get_email!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Email")
    |> assign(:email, %Email{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Emails")
    |> assign(:email, nil)
  end

  defp paginate_emails(socket, new_page) when new_page >= 1 do
    %{per_page: per_page, page: current_page, search: search} = socket.assigns
    emails = Emails.list_emails(offset: (new_page - 1) * per_page, limit: per_page, search: search)
    reset = new_page == 1

    {emails, at, limit} =
      if new_page >= current_page do
        {emails, -1, per_page * 3 * -1}
      else
        {Enum.reverse(emails), 0, per_page * 3}
      end

    case emails do
      [] ->
        assign(socket, end_of_timeline?: at == -1)
      [_ | _] = emails ->
        socket
        |> assign(end_of_timeline?: false)
        |> assign(page: new_page)
        |> stream(:emails, emails, at: at, limit: limit, reset: reset)
    end
  end

  @impl true
  def handle_info({MessageStreamWeb.EmailLive.FormComponent, {:saved, email}}, socket) do
    {:noreply, stream_insert(socket, :emails, email)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    email = Emails.get_email!(id)
    {:ok, _} = Emails.delete_email(email)

    {:noreply, stream_delete(socket, :emails, email)}
  end

  def handle_event("next-page", _, socket) do
    {:noreply, paginate_emails(socket, socket.assigns.page + 1)}
  end

  def handle_event("prev-page", %{"_overran" => true}, socket) do
    {:noreply, paginate_emails(socket, 1)}
  end

  def handle_event("prev-page", _, socket) do
    if socket.assigns.page > 1 do
      {:noreply, paginate_emails(socket, socket.assigns.page - 1)}
    else
      {:noreply, socket}
    end
  end

  def handle_event("search", %{"search" => search}, socket) do
    socket = assign(socket, search: search)
    socket = paginate_emails(socket, 1)
    {:noreply, socket}
  end
end
