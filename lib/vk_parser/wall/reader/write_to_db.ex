defmodule VkParser.Wall.Reader.WriteToDb do
  @moduledoc """
    Call API and write responses into PostsStorage.
  """

  use GenServer

  alias VkParser.Wall.{PostsStorage, Post}

  @max_posts_count 100


  def start_link(group, limit \\ 1000, callback \\ nil) do
    state = %{group: group, limit: limit, 
              offset: 0, callback: callback}

    GenServer.start_link(__MODULE__, state, name: __MODULE__)
    start
  end

  @doc """
  Start parsing wall. When Api will return [] or offset >= limit, 
  than parsing will be stopped and callback will be called.
  """
  def start do
    IO.puts("Wall parsing is started...")
    GenServer.cast(__MODULE__, :start)
  end

  def handle_cast(:start, state) do
    parse_in_db(state)
    {:noreply, state}
  end

  defp parse_in_db(state) do
    posts = get_posts(state.group, state.offset)

    if parse_ended?(state, posts) do
      IO.puts("Parse is successfull")
      if state.callback, do: state.callback.()
    else
      save_posts(posts)
      new_state = Map.put(state, 
                          :offset,
                          state.offset + @max_posts_count)
      sleep()
      parse_in_db(new_state)
    end
  end

  defp parse_ended?(state, posts) do
    posts == [] || state.offset >= state.limit
  end

  defp get_posts(group, offset) do 
    VkParser.VkApi.Wall.posts(group, offset, @max_posts_count)
  end

  # TODO: try ExRated 
  defp sleep do
    :timer.sleep(100)
  end

  defp save_posts(response) do
    spawn fn() ->
      response 
      |> Enum.each(fn(post) ->
        PostsStorage.push(
          %Post{ 
            id: post["id"],
            attachments: post["attachments"],
            likes_count: post["likes"]["count"] ,
            reposts_count: post["reposts"]["count"]
          }) 
        end)
    end
  end
end
