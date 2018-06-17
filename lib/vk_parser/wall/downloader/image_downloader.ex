require IEx;
defmodule VkParser.Wall.Downloader.ImageDownloader do
  @moduledoc """
    Downloads filtered images from Vk response
  """
  use GenStage

  alias VkParser.Wall.Downloader.ProducerConsumer

  @doc """
    Acceptable options are `src` and `src_big` 
  """
  @image_size "src_big"
  @folder "downloads/test/"

  def start_link do
    GenStage.start_link(__MODULE__, [], [])
  end

  def init(state) do
    {:consumer, state, 
      subscribe_to: [ProducerConsumer]}
  end

  def handle_events([group_name | posts], _from, state) do
    check_folder(group_name)

    posts |>
    Enum.each(fn(photo) ->
      download_image(photo[@image_size], 
                     path(group_name, filename(photo)))
    end)

    {:noreply, [], state}
  end

  defp download_image(url, path) do
     body = HTTPotion.get(url).body
     File.write!(path, body)
  end

  defp filename(photo) do
    photo["pid"]
  end

  defp path(group_name, name) do
    "#{folder(group_name)}/#{name}.png"
  end

  defp folder(group_name) do
    "downloads/#{group_name}"
  end

  defp check_folder(group_name) do
    unless File.dir?(folder(group_name)) do 
      File.mkdir_p(folder(group_name))
    end
  end
end
