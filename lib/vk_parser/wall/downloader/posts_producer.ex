require IEx
defmodule VkParser.Wall.Downloader.PostsProducer do
  @moduledoc """
  """

  use GenStage

  alias VkParser.Wall.PostsStorage

  def start_link(offset \\ 0) do
    GenStage.start_link(__MODULE__, 
                        %{offset: offset,
                          records: PostsStorage.state
                         }, 
                        name: __MODULE__)
  end

  def init(state) do
    {:producer, state} 
  end

  def handle_demand(count, state) do
    posts = Enum.slice(state.records, 0, count)
    new_state = state 
                |> Map.replace(:offset, state.offset + count)
                |> Map.replace(:records, Enum.drop(state.records, count))
    

    {:noreply, posts, new_state}
  end
end
