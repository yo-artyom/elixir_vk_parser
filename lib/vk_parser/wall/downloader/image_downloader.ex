require IEx;
defmodule VkParser.Wall.Downloader.ImageDownloader do
  @moduledoc """
    Downloads images from filtered Vk response
  """
  use GenStage

  @doc """
    Acceptable options are `src` and `src_big` 
  """
  @image_size "src_big"
  @folder "downloads/#{VkParser.group}"

  def start_link do
    GenStage.start_link(__MODULE__, [], [])
  end

  def init(state) do
    {:consumer, state, 
      subscribe_to: [VkParser.Wall.Downloader.ProducerConsumer]}
  end

  def handle_events(records, _from, state) do
    check_folder()

    records |>
    Enum.each(fn(photo) ->
      download_image(photo[@image_size], 
                     filename(photo))
    end)

    {:noreply, [], state}
  end

  defp download_image(url, name) do
     body = HTTPotion.get(url).body
     File.write!(path(name), body)
  end

  defp filename(photo) do
    photo["pid"]
  end

  defp path(name) do
    "#{@folder}/#{name}.png"
  end

  defp check_folder do
    unless File.dir?(@folder) do 
      File.mkdir_p(@folder)
    end
  end
end
