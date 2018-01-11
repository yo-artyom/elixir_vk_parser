require IEx
defmodule VkParser.Wall.PostsProducer do
  @moduledoc """
  Requests to VK API. 
  State of producer is current offset ( vk allow get only 100 records batches )
  """
  use GenStage


  def start_link(group, offset) do
    GenStage.start_link(__MODULE__, %{group: group, offset: offset }, name: __MODULE__)
  end

  def init(state) do
    {:producer, state} 
  end

  def handle_demand(count, state) do
    posts = get_posts(state.group, state.offset, count)
    new_state = state 
                |> Map.replace(:offset, state.offset + count)

    IO.inspect(new_state)
    {:noreply, posts, new_state}
  end

  def get_posts(group, offset, count) do 
    VkParser.VkApi.Wall.posts(group, offset, count)
  end
end
