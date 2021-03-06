defmodule VkParser.Wall.Post do
  @moduledoc """
    Struct for a wall post.
  """
  
  defstruct group_name: "",
    attachments: %{}, 
    likes_count: 0, 
    id: 0,
    reposts_count: 0
end
