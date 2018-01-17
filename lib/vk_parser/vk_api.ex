require IEx
defmodule VkParser.VkApi do
  @moduledoc """
    Wrapper for vk requests
  """

  defmodule Wall do

    def posts(group, offset, count \\ 100) do
      tl get_batch(group, offset, count)
    end

    def amount(group) do
      [amount | _] = get_batch(group, 0, 1)
      amount
    end

    def get_batch(group, offset, count) do 
        BalalaikaBear.Wall.get(%{domain: group,
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
