defmodule VkParser.Wall.Downloader.Supervisor do
  @moduledoc """
  """
  
  alias VkParser.Wall.Downloader.{PostsProducer, 
                                  ProducerConsumer, 
                                  ImageDownloader}
  alias VkParser.Wall.PostsStorage

  def start do
    import Supervisor.Spec, warn: false
    if PostsStorage.empty? do
      throw "PostsStorage is empty, nothing to Download"
    end

    children = [
      worker(PostsProducer, []),
      worker(ProducerConsumer, []),
      worker(ImageDownloader, [], id: 1),
      worker(ImageDownloader, [], id: 2),
      worker(ImageDownloader, [], id: 3),
      worker(ImageDownloader, [], id: 4)
    ]

    opts = [strategy: :one_for_one, name: __MODULE__]
    Supervisor.start_link(children, opts)
  end
end
