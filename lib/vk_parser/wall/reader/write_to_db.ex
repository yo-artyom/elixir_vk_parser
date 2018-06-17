defmodule VkParser.Wall.Reader.WriteToDb do
  @moduledoc """
    Call API and write responses into PostsStorage.
  """

  use GenServer

  alias VkParser.Wall.{PostsStorage, Post}

  @max_posts_count 100


  def start_link(group, limit \\ 1000, offset \\ 0,callback \\ nil) do
    state = %{group: group, limit: limit, 
              offset: offset, callback: callback}

    GenServer.start_link(__MODULE__, state, name: genserver_name(state))

    start(state)
  end

  @doc """
  Start parsing wall. When Api will return [] or offset >= limit, 
  than parsing will be stopped and callback will be called.
  """
  def start(state) do
    IO.puts("Wall parsing for #{state.group} has started...")
    GenServer.cast(genserver_name(state), :start)
  end

  def handle_cast(:start, state) do
    parse_in_db(state)
    {:noreply, state}
  end

  defp parse_in_db(state) do
    IO.inspect("Current offset is #{state.offset}")
    posts = get_posts(state.group, state.offset)

    if parse_ended?(state, posts) do
      IO.puts("Parsing is successfull")
      if state.callback, do: state.callback.()
    else
      save_posts(state, posts)
      new_state = Map.put(state, 
                          :offset,
                          state.offset + @max_posts_count)
      sleep()
      parse_in_db(new_state)
    end
  end

  defp genserver_name(state) do
    "#{__MODULE__}_#{state.group}"
    |> String.to_atom
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

  defp save_posts(state, response) do
    IO.puts "save called for #{state.group}" 
    spawn fn() ->
      response 
      |> Enum.each(fn(post) ->
        PostsStorage.push(
          state.group,
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
