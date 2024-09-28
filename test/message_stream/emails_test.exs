defmodule MessageStream.EmailsTest do
  use MessageStream.DataCase

  alias MessageStream.Emails

  describe "emails" do
    alias MessageStream.Emails.Email

    import MessageStream.EmailsFixtures

    @invalid_attrs %{bcc_email: nil, body: nil, cc_email: nil, from_email: nil, subject: nil, to_email: nil}

    test "list_emails/0 returns all emails" do
      email = email_fixture()
      assert Emails.list_emails() == [email]
    end

    test "get_email!/1 returns the email with given id" do
      email = email_fixture()
      assert Emails.get_email!(email.id) == email
    end

    test "create_email/1 with valid data creates a email" do
      valid_attrs = %{bcc_email: "some bcc_email", body: "some body", cc_email: "some cc_email", from_email: "some from_email", subject: "some subject", to_email: "some to_email"}

      assert {:ok, %Email{} = email} = Emails.create_email(valid_attrs)
      assert email.bcc_email == "some bcc_email"
      assert email.body == "some body"
      assert email.cc_email == "some cc_email"
      assert email.from_email == "some from_email"
      assert email.subject == "some subject"
      assert email.to_email == "some to_email"
    end

    test "create_email/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Emails.create_email(@invalid_attrs)
    end

    test "update_email/2 with valid data updates the email" do
      email = email_fixture()
      update_attrs = %{bcc_email: "some updated bcc_email", body: "some updated body", cc_email: "some updated cc_email", from_email: "some updated from_email", subject: "some updated subject", to_email: "some updated to_email"}

      assert {:ok, %Email{} = email} = Emails.update_email(email, update_attrs)
      assert email.bcc_email == "some updated bcc_email"
      assert email.body == "some updated body"
      assert email.cc_email == "some updated cc_email"
      assert email.from_email == "some updated from_email"
      assert email.subject == "some updated subject"
      assert email.to_email == "some updated to_email"
    end

    test "update_email/2 with invalid data returns error changeset" do
      email = email_fixture()
      assert {:error, %Ecto.Changeset{}} = Emails.update_email(email, @invalid_attrs)
      assert email == Emails.get_email!(email.id)
    end

    test "delete_email/1 deletes the email" do
      email = email_fixture()
      assert {:ok, %Email{}} = Emails.delete_email(email)
      assert_raise Ecto.NoResultsError, fn -> Emails.get_email!(email.id) end
    end

    test "change_email/1 returns a email changeset" do
      email = email_fixture()
      assert %Ecto.Changeset{} = Emails.change_email(email)
    end
  end
end
