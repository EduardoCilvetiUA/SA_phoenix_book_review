defmodule PhoenixBookReview.Services.CacheService do
  @moduledoc false
  require Logger

  def enabled? do
    System.get_env("REDIS_ENABLED", "false") == "true"
  end

  def get(key) do
    if enabled?() do
      try do
        case Redix.command(:redix, ["GET", key]) do
          {:ok, nil} -> nil
          {:ok, value} -> 
            value
            |> Jason.decode!()
            |> atomize_keys()
          {:error, reason} -> 
            Logger.error("Redis GET error: #{inspect(reason)}")
            nil
        end
      rescue
        e -> 
          Logger.error("Redis GET exception: #{inspect(e)}")
          nil
      end
    else
      nil
    end
  end

  defp atomize_keys(map) when is_map(map) do
    Map.new(map, fn {k, v} -> {String.to_atom(k), atomize_keys(v)} end)
  end

  defp atomize_keys(list) when is_list(list) do
    Enum.map(list, &atomize_keys/1)
  end

  defp atomize_keys(value), do: value

  def set(key, value, ttl \\ 3600) do
    if enabled?() do
      try do
        json_value = Jason.encode!(value)
        case Redix.command(:redix, ["SETEX", key, ttl, json_value]) do
          {:ok, _} -> 
            Logger.info("Redis SET success: #{key}")
            :ok
          {:error, reason} -> 
            Logger.error("Redis SET error: #{inspect(reason)}")
            :error
        end
      rescue
        e -> 
          Logger.error("Redis SET exception: #{inspect(e)}")
          :error
      end
    else
      :ok
    end
  end

  def delete(key) do
    if enabled?() do
      try do
        Redix.command(:redix, ["DEL", key])
        :ok
      rescue
        _ -> :error
      end
    else
      :ok
    end
  end

  def delete_pattern(pattern) do
    if enabled?() do
      try do
        case Redix.command(:redix, ["KEYS", pattern]) do
          {:ok, keys} when is_list(keys) ->
            if length(keys) > 0 do
              Redix.command(:redix, ["DEL"] ++ keys)
            end
          _ -> :ok
        end
        :ok
      rescue
        _ -> :error
      end
    else
      :ok
    end
  end
end