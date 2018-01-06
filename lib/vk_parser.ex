defmodule VkParser do
  @moduledoc """
    Application for downloading items from VK wall.
    App is using GenStage for the scraping process. 

    `Wall.PostsProducer` scrapings posts from a vk wall.

    `ProductConsumer` uses filter to left only records with selected type.

    `Wall.ImageDownloader` is using for the saving images in downloaded folder.
  """
  use Application

  @group "rbc"
  @access_token nil 

  def start(_t , _a) do
    import Supervisor.Spec, warn: false

    children = [
      worker(VkParser.Wall.PostsProducer, [@group, 0]),
      worker(VkParser.Wall.ProducerConsumer, []),
      worker(VkParser.Wall.ImageDownloader, [], id: 1),
      worker(VkParser.Wall.ImageDownloader, [], id: 2),
      worker(VkParser.Wall.ImageDownloader, [], id: 3),
      worker(VkParser.Wall.ImageDownloader, [], id: 4)
    ]

    IO.puts access_token
    opts = [strategy: :one_for_one, name: VkParser.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def group, do: @group

  def access_token do 
    cond do
      @access_token -> @access_token
      {:ok, token} = File.read(".access_token") -> 
        token |> String.replace("\n", "")
    end
  end
end
