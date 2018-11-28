require IEx
defmodule VkParser.VkApi do
  @moduledoc """
  Wrapper for VK requests
  """

  defmodule Wall do
    @moduledoc """
    """

    @doc """
    Returns [%{}]. Structure of a single post can be founded here:
    https://vk.com/dev/wall.post
    """
    def posts(group, offset, count \\ 100) do
      tl get_batch(group, offset, count)
    end

    @doc """
    Returns the amount of posts on a group wall
    """
    def amount(group) do
      [amount | _] = get_batch(group, 0, 1)
      amount
    end

    @doc false
    defp get_batch(group, offset, count) do
      BalalaikaBear.Wall.get(%{
                                v: 3,
                                domain: group,
                                offset: offset,
                                count: count,
                                access_token: VkParser.access_token
                              })
        |> case do
          {:ok, response} -> response
          {:error, message} -> throw(message["error_msg"])
        end
    end
  end
end
