defmodule VkParser.Wall.Downloader.ProducerConsumer do
  @moduledoc """
    Filter for the records.
  """

  use GenStage

  alias VkParser.Wall.Filters.{Images, LikeCount}
  alias VkParser.Wall.Downloader.PostsProducer

  @filters [LikeCount, Images]

  def start_link do
    GenStage.start_link(__MODULE__, :no_matter, name: __MODULE__)
  end

  def init(state) do
    {:producer_consumer, state, 
      subscribe_to: [{PostsProducer, max_demand: 100, min_demand: 1}]}
  end

  def handle_events(posts, _from, state) do
    filtered = apply_filters(posts, @filters)

    {:noreply, filtered, state}
  end

  defp apply_filters(posts, []), do: posts

  defp apply_filters(posts, filters) do
    new_records = hd(filters).filter(posts)
    apply_filters(new_records, tl(filters))
  end
end
