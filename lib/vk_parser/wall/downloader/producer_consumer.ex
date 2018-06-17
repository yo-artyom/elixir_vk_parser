defmodule VkParser.Wall.Downloader.ProducerConsumer do
  @moduledoc """
    Filter for the records.
  """

  use GenStage

  alias VkParser.Wall.Filters.{Images, LikeCount}
  alias VkParser.Wall.Downloader.PostsProducer

  # @filters [ LikeCount, Images ]
  @filters [ Images ]

  def start_link do
    GenStage.start_link(__MODULE__, :no_matter, name: __MODULE__)
  end

  def init(state) do
    {:producer_consumer, state, 
      subscribe_to: [{PostsProducer, max_demand: 100}]}
  end

  def handle_events([group_name | posts], _from, state) do
    filtered = apply_filters(group_name, posts, @filters)

    {:noreply, [group_name] ++ filtered, state}
  end

  defp apply_filters(_, posts, []), do: posts

  defp apply_filters(group_name, posts, filters) do
    new_records = hd(filters).filter(%{group_name: group_name,
                                      posts: posts})

    apply_filters(group_name, new_records, tl(filters))
  end
end
