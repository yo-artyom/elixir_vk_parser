defmodule VkParser.Wall.Filters.Images do
  @moduledoc """
    Selects only posts with the photo attachments
  """
  def filter(posts) do
    posts 
    |> Stream.filter(&(&1.attachments != nil)) 
    |> Enum.filter(fn(post) ->
      post
      |> attachemnt_types
      |> Enum.member?("photo")
    end)
  end

  defp attachemnt_types(post) do
    Enum.map(post.attachments, &(&1["type"]))
  end
end
