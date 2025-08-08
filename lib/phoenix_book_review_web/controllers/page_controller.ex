defmodule PhoenixBookReviewWeb.PageController do
  use PhoenixBookReviewWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
