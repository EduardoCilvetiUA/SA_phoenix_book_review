defmodule PhoenixBookReview.Repo.Migrations.CreateReviews do
  use Ecto.Migration

  def change do
    create table(:reviews) do
      add :review_text, :text, null: false
      add :score, :integer, null: false
      add :upvotes, :integer, default: 0
      add :book_id, references(:books, on_delete: :nothing)

      timestamps()
    end

    create index(:reviews, [:book_id])
  end
end
