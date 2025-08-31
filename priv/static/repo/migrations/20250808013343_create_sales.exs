defmodule PhoenixBookReview.Repo.Migrations.CreateSales do
  use Ecto.Migration

  def change do
    create table(:sales) do
      add :year, :integer, null: false
      add :sales_amount, :integer, null: false
      add :book_id, references(:books, on_delete: :nothing)

      timestamps()
    end

    create index(:sales, [:book_id])
    create index(:sales, [:year])
  end
end
