require IEx
defmodule VkParser.Wall.Downloader.PostsProducer do
  @moduledoc """
  """

  use GenStage

  alias VkParser.Wall.{PostsStorage, Post}

  def start_link(offset \\ 0) do
    GenStage.start_link(__MODULE__, %{offset: offset}, name: __MODULE__)
  end

  def init(state) do
    {:producer, state} 
  end

  def handle_demand(count, state) do
    new_state = state 
                |> Map.replace(:offset, state.offset + count)
    posts = List.take(VkParser.Wall.PostsStorage.state, count)
    

    {:noreply, posts, new_state}
  end

  defp get_posts(group, offset, count) do 
  end
end
