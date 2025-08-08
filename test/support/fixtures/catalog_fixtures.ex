defmodule PhoenixBookReview.CatalogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PhoenixBookReview.Catalog` context.
  """

  @doc """
  Generate a author.
  """
  def author_fixture(attrs \\ %{}) do
    {:ok, author} =
      attrs
      |> Enum.into(%{
        country_of_origin: "some country_of_origin",
        date_of_birth: ~D[2025-08-07],
        description: "some description",
        name: "some name"
      })
      |> PhoenixBookReview.Catalog.create_author()

    author
  end
end
