defmodule PhoenixBookReview.CatalogTest do
  use PhoenixBookReview.DataCase

  alias PhoenixBookReview.Catalog

  describe "authors" do
    alias PhoenixBookReview.Catalog.Author

    import PhoenixBookReview.CatalogFixtures

    @invalid_attrs %{name: nil, description: nil, date_of_birth: nil, country_of_origin: nil}

    test "list_authors/0 returns all authors" do
      author = author_fixture()
      assert Catalog.list_authors() == [author]
    end

    test "get_author!/1 returns the author with given id" do
      author = author_fixture()
      assert Catalog.get_author!(author.id) == author
    end

    test "create_author/1 with valid data creates a author" do
      valid_attrs = %{name: "some name", description: "some description", date_of_birth: ~D[2025-08-07], country_of_origin: "some country_of_origin"}

      assert {:ok, %Author{} = author} = Catalog.create_author(valid_attrs)
      assert author.name == "some name"
      assert author.description == "some description"
      assert author.date_of_birth == ~D[2025-08-07]
      assert author.country_of_origin == "some country_of_origin"
    end

    test "create_author/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalog.create_author(@invalid_attrs)
    end

    test "update_author/2 with valid data updates the author" do
      author = author_fixture()
      update_attrs = %{name: "some updated name", description: "some updated description", date_of_birth: ~D[2025-08-08], country_of_origin: "some updated country_of_origin"}

      assert {:ok, %Author{} = author} = Catalog.update_author(author, update_attrs)
      assert author.name == "some updated name"
      assert author.description == "some updated description"
      assert author.date_of_birth == ~D[2025-08-08]
      assert author.country_of_origin == "some updated country_of_origin"
    end

    test "update_author/2 with invalid data returns error changeset" do
      author = author_fixture()
      assert {:error, %Ecto.Changeset{}} = Catalog.update_author(author, @invalid_attrs)
      assert author == Catalog.get_author!(author.id)
    end

    test "delete_author/1 deletes the author" do
      author = author_fixture()
      assert {:ok, %Author{}} = Catalog.delete_author(author)
      assert_raise Ecto.NoResultsError, fn -> Catalog.get_author!(author.id) end
    end

    test "change_author/1 returns a author changeset" do
      author = author_fixture()
      assert %Ecto.Changeset{} = Catalog.change_author(author)
    end
  end
end
