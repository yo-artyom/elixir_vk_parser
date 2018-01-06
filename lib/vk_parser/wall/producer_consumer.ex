defmodule VkParser.Wall.ProducerConsumer do
  @moduledoc """
    Filter for the records.
  """

  use GenStage

  @filter VkParser.Wall.Filters.Images

  def start_link do
    GenStage.start_link(__MODULE__, :no_matter, name: __MODULE__)
  end

  def init(state) do
    {:producer_consumer, state, 
      subscribe_to: [{VkParser.Wall.PostsProducer, max_demand: 100}]}
  end

  def handle_events(posts, _from, state) do
    images = @filter.select(posts)
    {:noreply, images, state}
  end
end
