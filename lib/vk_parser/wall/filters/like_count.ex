defmodule VkParser.Wall.Filters.LikeCount do
  alias VkParser.Wall.Analytics.Math

  def filter(%{group_name: group, posts: posts}) do
    IO.puts "Entered: #{length(posts)}"

    res = posts
    |> Enum.filter( fn(post) ->
      post.likes_count >= Math.median(group) &&
      post.reposts_count >= Math.median(group, :reposts_count)
    end)

    IO.puts "Out: #{length(res)}"
    res
  end
end
