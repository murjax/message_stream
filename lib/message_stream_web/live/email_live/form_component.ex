defmodule MessageStreamWeb.EmailLive.FormComponent do
  use MessageStreamWeb, :live_component

  alias MessageStream.Emails

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage email records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="email-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:from_email]} type="text" label="From email" />
        <.input field={@form[:to_email]} type="text" label="To email" />
        <.input field={@form[:cc_email]} type="text" label="Cc email" />
        <.input field={@form[:bcc_email]} type="text" label="Bcc email" />
        <.input field={@form[:subject]} type="text" label="Subject" />
        <.input field={@form[:body]} type="text" label="Body" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Email</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{email: email} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Emails.change_email(email))
     end)}
  end

  @impl true
  def handle_event("validate", %{"email" => email_params}, socket) do
    changeset = Emails.change_email(socket.assigns.email, email_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"email" => email_params}, socket) do
    save_email(socket, socket.assigns.action, email_params)
  end

  defp save_email(socket, :edit, email_params) do
    case Emails.update_email(socket.assigns.email, email_params) do
      {:ok, email} ->
        notify_parent({:saved, email})

        {:noreply,
         socket
         |> put_flash(:info, "Email updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_email(socket, :new, email_params) do
    case Emails.create_email(email_params) do
      {:ok, email} ->
        notify_parent({:saved, email})

        {:noreply,
         socket
         |> put_flash(:info, "Email created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
