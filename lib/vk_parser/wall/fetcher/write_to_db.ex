defmodule VkParser.Wall.Fetcher.WriteToDb do
  @moduledoc """
    Call API and write responses into `PostsStorage`
  """
  use GenServer

  alias VkParser.Wall.{PostsStorage, Post}

  @max_posts_count 100

  def start_link(group, limit \\ 1000, offset \\ 0, callback \\ nil) do
    total_posts_amount = VkParser.VkApi.Wall.amount(group)
    limit = [total_posts_amount, limit ] |> Enum.min

    state = %{group: group, limit: limit,
              offset: offset, callback: callback}

    GenServer.start_link(__MODULE__, state, name: genserver_name(state))

    start(state)
  end

  @doc """
  Start parsing wall. 
  Parsing will be stopped when Api returns [] or offset >= limit.
  Callback will be called after parsing
  """
  def start(state) do
    IO.puts("""
    Wall parsing for #{state.group} has started...
    Total post amount:  #{state.limit}
    """)

    GenServer.cast(genserver_name(state), :start)
  end

  @impl true
  def init(args) do
    {:ok, args}
  end

  @impl true
  def handle_cast(:start, state) do
    parse_in_db(state)
    {:noreply, state}
  end

  defp parse_in_db(state) do
    posts = get_posts(state.group, state.offset)

    if parse_ended?(state, posts) do
      IO.puts("Parsing for #{state.group} is successfull")
      if state.callback, do: state.callback.()
    else
      save_posts(state, posts)
      new_state = Map.put(state, 
                          :offset,
                          state.offset + @max_posts_count)
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

  defp save_posts(state, response) do
    spawn fn() ->
      response 
      |> Enum.each(fn(post) ->
        PostsStorage.push(
          %Post{ 
            id: post["id"],
            group_name: state.group,
            attachments: post["attachments"],
            likes_count: post["likes"]["count"] ,
            reposts_count: post["reposts"]["count"]
          }) 
          end)
    end
  end
end
