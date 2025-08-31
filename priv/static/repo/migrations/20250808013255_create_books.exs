defmodule PhoenixBookReview.Repo.Migrations.CreateBooks do
  use Ecto.Migration

  def change do
    create table(:books) do
      add :name, :string, null: false
      add :summary, :text
      add :date_of_publication, :date
      add :number_of_sales, :integer, default: 0
      add :author_id, references(:authors, on_delete: :nothing)

      timestamps()
    end

    create index(:books, [:author_id])
  end
end
