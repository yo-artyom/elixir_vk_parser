require IEx
defmodule VkParser.Wall.Downloader.PostsProducer do
  @moduledoc """
  Read PostsStorage for the posts demand created by ImageDowloader.
  
  """

  use GenStage

  alias VkParser.Wall.PostsStorage

  def start_link(offset \\ 0) do
    GenStage.start_link(__MODULE__, 
                        %{offset: offset,
                          group_queue: initial_queue() }, 
                        name: __MODULE__)
  end

  # records: %{group_name: [%Post]}

  # records: PostsStorage.state,
  def init(state) do
    {:producer, state} 
  end

  def handle_demand(count, state) do
    new_state =
      if (state.offset >= current_group_images_length(state)) do
        next_group_state(state)
      else
        state
      end

    new_state = new_state 
                |> Map.replace(:offset, new_state.offset + count)
    if current_group(state) == [] do
      IO.puts "ERORORRO"
    end

    {:noreply, [current_group(state)] ++ next_posts(state, count), new_state}
  end

  def current_group(state) do
    hd state.group_queue
  end

  def initial_queue do
    PostsStorage.state
    |> Map.keys
  end

  def next_group_state(state) do
    new_queue = tl(state.group_queue)
    state
    |> Map.replace(:offset, 0)
    |> Map.replace(:group_queue, new_queue)
  end

  def next_posts(state, count) do
    PostsStorage.state[current_group(state)] |>
    Enum.slice(state.offset, count)
  end

  def current_group_images_length(state) do
    length PostsStorage.state[current_group(state)]
  end
end
