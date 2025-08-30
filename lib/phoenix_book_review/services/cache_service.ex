defmodule PhoenixBookReview.Services.CacheService do
  @moduledoc false
  require Logger

  def enabled? do
    enabled = System.get_env("REDIS_ENABLED", "false") == "true"
    Logger.debug("Cache service Redis enabled check: #{enabled}")
    enabled
  end

  def get(key) do
    Logger.debug("Cache GET request for key: #{key}")
    if enabled?() do
      try do
        case Redix.command(:redix, ["GET", key]) do
          {:ok, nil} -> 
            Logger.debug("Cache miss for key: #{key}")
            nil
          {:ok, value} -> 
            Logger.debug("Cache hit for key: #{key}")
            value
            |> Jason.decode!()
            |> atomize_keys()
          {:error, reason} -> 
            Logger.error("Cache GET error for key #{key}: #{inspect(reason)}")
            nil
        end
      rescue
        e -> 
          Logger.error("Cache GET exception for key #{key}: #{inspect(e)}")
          nil
      end
    else
      Logger.debug("Cache disabled, returning nil for key: #{key}")
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
    Logger.debug("Cache SET request for key: #{key}, TTL: #{ttl}")
    if enabled?() do
      try do
        json_value = Jason.encode!(value)
        case Redix.command(:redix, ["SETEX", key, ttl, json_value]) do
          {:ok, _} -> 
            Logger.debug("Cache SET success for key: #{key}")
            :ok
          {:error, reason} -> 
            Logger.error("Cache SET error for key #{key}: #{inspect(reason)}")
            :error
        end
      rescue
        e -> 
          Logger.error("Cache SET exception for key #{key}: #{inspect(e)}")
          :error
      end
    else
      Logger.debug("Cache disabled, skipping SET for key: #{key}")
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