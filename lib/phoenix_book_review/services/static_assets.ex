defmodule PhoenixBookReview.Services.StaticAssets do
  @moduledoc false

  def served_by_proxy? do
    System.get_env("STATIC_ASSETS_SERVED_BY_PROXY", "false") == "true"
  end

  def asset_url(path) when is_binary(path) do
    if __MODULE__.served_by_proxy? do
      # When using proxy, assets are served by Caddy directly
      path
    else
      # When not using proxy, assets are served by Phoenix
      path
    end
  end

  def asset_url(nil), do: nil
end