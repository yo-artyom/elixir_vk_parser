require IEx
defmodule VkParser.Wall.Downloader.PostsProducer do
  @moduledoc """
  Read PostsStorage for the posts demand created by ImageDowloader.
  """

  use GenStage

  alias VkParser.Wall.PostsStorage

  def start_link(offset \\ 0) do
    GenStage.start_link(__MODULE__, %{offset: offset}, name: __MODULE__)
  end

  def init(state) do
    {:producer, state} 
  end

  def handle_demand(count, state) do
    new_state = state
                |> Map.replace(:offset, state.offset + count)

    {:noreply, next_posts(state, count), new_state}
  end

  def next_posts(state, count) do
    PostsStorage.state 
    |> Enum.slice(state.offset, count)
  end
end
