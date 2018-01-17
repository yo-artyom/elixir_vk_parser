defmodule VkParser.Wall.Post do
  @moduledoc """
    Struct for the wall post.
  """
  
  defstruct attachments: %{}, 
    likes_count: 0, 
    id: 0,
    reposts_count: 0
end
