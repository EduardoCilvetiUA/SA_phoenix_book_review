defmodule PhoenixBookReview.Repo.Migrations.CreateAuthors do
  use Ecto.Migration

  def change do
    create table(:authors) do
      add :name, :string
      add :date_of_birth, :date
      add :country_of_origin, :string
      add :description, :text

      timestamps(type: :utc_datetime)
    end
  end
end
