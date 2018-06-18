defmodule VkParser.Wall.Filters.LikeCount do
  @moduledoc """
  Filter responsible for selecting posts that have like and repost count
  more than average in a selected group
  """
  alias VkParser.Wall.Analytics.Math

  def filter(posts) do
    IO.puts "Entered: #{length(posts)}"

    res = posts
    |> Enum.filter(fn(post) ->
      post.likes_count >= Math.median(post.group_name) &&
      post.reposts_count >= Math.median(post.group_name, :reposts_count)
    end)

    IO.puts "Out: #{length(res)}"
    res
  end
end
