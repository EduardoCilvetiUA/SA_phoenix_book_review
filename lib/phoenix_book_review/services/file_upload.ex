defmodule PhoenixBookReview.Services.FileUpload do
  @moduledoc false

  def upload_path do
    System.get_env("UPLOAD_PATH", "priv/static/uploads")
  end

  def handle_upload(upload, type) do
    if upload && upload.filename do
      filename = generate_filename(upload.filename, type)
      destination = Path.join(upload_path(), filename)
      
      File.mkdir_p!(Path.dirname(destination))
      
      case File.cp(upload.path, destination) do
        :ok -> {:ok, "/uploads/#{filename}"}
        {:error, reason} -> {:error, reason}
      end
    else
      {:ok, nil}
    end
  end

  defp generate_filename(original_filename, type) do
    timestamp = System.system_time(:second)
    extension = Path.extname(original_filename)
    "#{type}_#{timestamp}_#{:rand.uniform(1000)}#{extension}"
  end

  def delete_file(nil), do: :ok
  def delete_file(path) when is_binary(path) do
    full_path = Path.join("priv/static", String.trim_leading(path, "/"))
    
    if File.exists?(full_path) do
      File.rm(full_path)
    else
      :ok
    end
  end
end