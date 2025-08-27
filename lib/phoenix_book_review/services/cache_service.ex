defmodule PhoenixBookReview.Services.CacheService do
  @moduledoc false
  require Logger

  def enabled? do
    enabled = System.get_env("REDIS_ENABLED", "false") == "true"
    Logger.info("🔴 CACHE DEBUG: Redis enabled check: #{enabled}")
    enabled
  end

  def get(key) do
    Logger.info("🔴 CACHE DEBUG: GET request for key: #{key}")
    if enabled?() do
      try do
        case Redix.command(:redix, ["GET", key]) do
          {:ok, nil} -> 
            Logger.info("🟡 CACHE DEBUG: Key not found: #{key}")
            nil
          {:ok, value} -> 
            Logger.info("🟢 CACHE DEBUG: Cache HIT for key: #{key}")
            value
            |> Jason.decode!()
            |> atomize_keys()
          {:error, reason} -> 
            Logger.error("🔴 CACHE DEBUG: Redis GET error: #{inspect(reason)}")
            nil
        end
      rescue
        e -> 
          Logger.error("🔴 CACHE DEBUG: Redis GET exception: #{inspect(e)}")
          nil
      end
    else
      Logger.info("🟡 CACHE DEBUG: Redis disabled, returning nil for key: #{key}")
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
    Logger.info("🔴 CACHE DEBUG: SET request for key: #{key}, TTL: #{ttl}")
    if enabled?() do
      try do
        json_value = Jason.encode!(value)
        case Redix.command(:redix, ["SETEX", key, ttl, json_value]) do
          {:ok, _} -> 
            Logger.info("🟢 CACHE DEBUG: SET success: #{key}")
            :ok
          {:error, reason} -> 
            Logger.error("🔴 CACHE DEBUG: SET error: #{inspect(reason)}")
            :error
        end
      rescue
        e -> 
          Logger.error("🔴 CACHE DEBUG: SET exception: #{inspect(e)}")
          :error
      end
    else
      Logger.info("🟡 CACHE DEBUG: Redis disabled, skipping SET for key: #{key}")
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