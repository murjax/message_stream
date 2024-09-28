defmodule MessageStream.Repo.Migrations.CreateEmails do
  use Ecto.Migration

  def change do
    create table(:emails) do
      add :from_email, :string
      add :to_email, :string
      add :cc_email, :string
      add :bcc_email, :string
      add :subject, :string
      add :body, :string

      timestamps(type: :utc_datetime)
    end
  end
end
