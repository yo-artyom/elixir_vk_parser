defmodule VkParser do
  @moduledoc """
    Application for downloading items from VK wall.
    App is using GenStage for the scraping process. 

    `Wall.PostsProducer` scrapings posts from a vk wall.

    `ProductConsumer` uses filter to left only records with selected type.

    `Wall.ImageDownloader` is using for the saving images in downloaded folder.
  """
  use Application

  def start(_t , _a) do
    import Supervisor.Spec, warn: false

    children = [
      worker(VkParser.Wall.PostsProducer, [group(), 0]),
      worker(VkParser.Wall.ProducerConsumer, []),
      worker(VkParser.Wall.ImageDownloader, [], id: 1),
      worker(VkParser.Wall.ImageDownloader, [], id: 2),
      worker(VkParser.Wall.ImageDownloader, [], id: 3),
      worker(VkParser.Wall.ImageDownloader, [], id: 4)
    ]

    opts = [strategy: :one_for_one, name: VkParser.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def group do
    {:ok, group } = Application.fetch_env(:vk_parser, :group)
    if group == nil, do: throw("You need to set up group in config!")
    group
  end

  def access_token do 
    case Application.fetch_env(:vk_parser, :access_token) do
      {:ok, nil } ->
        case check_access_token_file() do
          :not_found -> throw("Access token isn't setted")
          token -> token
        end
      {:ok, token} -> token
    end
  end

  defp check_access_token_file do
    case File.read(".access_token") do
      {:ok, token} ->
        token |> String.replace("\n", "")
      {:error, _ } -> :not_found
    end
  end
end
