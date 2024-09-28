defmodule MessageStream.EmailsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `MessageStream.Emails` context.
  """

  @doc """
  Generate a email.
  """
  def email_fixture(attrs \\ %{}) do
    {:ok, email} =
      attrs
      |> Enum.into(%{
        bcc_email: "some bcc_email",
        body: "some body",
        cc_email: "some cc_email",
        from_email: "some from_email",
        subject: "some subject",
        to_email: "some to_email"
      })
      |> MessageStream.Emails.create_email()

    email
  end
end
