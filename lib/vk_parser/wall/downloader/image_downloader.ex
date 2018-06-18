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

  def start_link do
    GenStage.start_link(__MODULE__, [], [])
  end

  def init(state) do
    {:consumer, state, 
      subscribe_to: [ProducerConsumer]}
  end

  def handle_events(posts, _from, state) do
    posts
    |> Enum.map(fn(post) -> post.group_name end)
    |> Enum.uniq
    |> Enum.each(&check_folder(&1))

    posts |>
    Enum.each(fn(post) ->
      post
      |> photo_attachments
      |> Enum.each(fn(photo) -> 
        download_image(photo[@image_size], 
                       path(post.group_name, photo)) 
      end)
    end)

    {:noreply, [], state}
  end

  defp download_image(url, path) do
     body = HTTPotion.get(url).body
     File.write!(path, body)
  end

  defp photo_attachments(post) do
    post.attachments
    |> Enum.filter(fn(attachment) ->
      attachment["type"] == "photo"
    end)
    |> Enum.map(&(&1["photo"]))
  end

  defp path(group_name, photo) do
    "#{folder(group_name)}/#{filename(photo)}.png"
  end

  defp filename(photo) do
    photo["pid"]
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
