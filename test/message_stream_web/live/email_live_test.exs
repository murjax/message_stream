defmodule MessageStreamWeb.EmailLiveTest do
  use MessageStreamWeb.ConnCase

  import Phoenix.LiveViewTest
  import MessageStream.EmailsFixtures

  @create_attrs %{bcc_email: "some bcc_email", body: "some body", cc_email: "some cc_email", from_email: "some from_email", subject: "some subject", to_email: "some to_email"}
  @update_attrs %{bcc_email: "some updated bcc_email", body: "some updated body", cc_email: "some updated cc_email", from_email: "some updated from_email", subject: "some updated subject", to_email: "some updated to_email"}
  @invalid_attrs %{bcc_email: nil, body: nil, cc_email: nil, from_email: nil, subject: nil, to_email: nil}

  defp create_email(_) do
    email = email_fixture()
    %{email: email}
  end

  describe "Index" do
    setup [:create_email]

    test "lists all emails", %{conn: conn, email: email} do
      {:ok, _index_live, html} = live(conn, ~p"/emails")

      assert html =~ "Listing Emails"
      assert html =~ email.bcc_email
    end

    test "saves new email", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/emails")

      assert index_live |> element("a", "New Email") |> render_click() =~
               "New Email"

      assert_patch(index_live, ~p"/emails/new")

      assert index_live
             |> form("#email-form", email: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#email-form", email: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/emails")

      html = render(index_live)
      assert html =~ "Email created successfully"
      assert html =~ "some bcc_email"
    end

    test "updates email in listing", %{conn: conn, email: email} do
      {:ok, index_live, _html} = live(conn, ~p"/emails")

      assert index_live |> element("#emails-#{email.id} a", "Edit") |> render_click() =~
               "Edit Email"

      assert_patch(index_live, ~p"/emails/#{email}/edit")

      assert index_live
             |> form("#email-form", email: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#email-form", email: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/emails")

      html = render(index_live)
      assert html =~ "Email updated successfully"
      assert html =~ "some updated bcc_email"
    end

    test "deletes email in listing", %{conn: conn, email: email} do
      {:ok, index_live, _html} = live(conn, ~p"/emails")

      assert index_live |> element("#emails-#{email.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#emails-#{email.id}")
    end
  end

  describe "Show" do
    setup [:create_email]

    test "displays email", %{conn: conn, email: email} do
      {:ok, _show_live, html} = live(conn, ~p"/emails/#{email}")

      assert html =~ "Show Email"
      assert html =~ email.bcc_email
    end

    test "updates email within modal", %{conn: conn, email: email} do
      {:ok, show_live, _html} = live(conn, ~p"/emails/#{email}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Email"

      assert_patch(show_live, ~p"/emails/#{email}/show/edit")

      assert show_live
             |> form("#email-form", email: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#email-form", email: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/emails/#{email}")

      html = render(show_live)
      assert html =~ "Email updated successfully"
      assert html =~ "some updated bcc_email"
    end
  end
end
