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
     tl get_batch(group, offset, count)
  end
  
  def amount(group) do
    [amount | _] = get_batch(group, 0, 1)
    amount
  end

  defp api_call_url(group, offset, count) do
    "https://api.vk.com/method/wall.get?domain=#{group}" <>
      "&count=#{count}&offset=#{offset}&access_token=#{VkParser.access_token}"
  end

  defp get_batch(group, offset, count) do
    get_data(group, offset, count)
  end

  def get_data(group, offset, count) do
    HTTPotion.get(api_call_url(group, offset, count)).body 
    |> Poison.Parser.parse! 
    |> check_errors 
    |> Map.get("response")
  end

  defp check_errors(response) do
    case Map.fetch(response, "error") do
      {:ok, error} ->
        throw(error)
      _ -> 
        response
    end
  end
end
