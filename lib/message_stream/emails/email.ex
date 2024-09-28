defmodule MessageStream.Emails.Email do
  use Ecto.Schema
  import Ecto.Changeset

  schema "emails" do
    field :bcc_email, :string
    field :body, :string
    field :cc_email, :string
    field :from_email, :string
    field :subject, :string
    field :to_email, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(email, attrs) do
    email
    |> cast(attrs, [:from_email, :to_email, :cc_email, :bcc_email, :subject, :body])
    |> validate_required([:from_email, :to_email, :cc_email, :bcc_email, :subject, :body])
  end
end
