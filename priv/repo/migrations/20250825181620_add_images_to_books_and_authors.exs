defmodule PhoenixBookReview.Repo.Migrations.AddImagesToBooksAndAuthors do
  use Ecto.Migration

  def change do
    alter table(:books) do
      add :cover_image, :string
    end

    alter table(:authors) do
      add :profile_image, :string
    end
  end
end
