defmodule VkParser.Wall.Filters.LikeCount do
  alias VkParser.Wall.Analytics.Math

  def filter(response) do
    IO.puts "Entered: #{length(response)}"
    res= response
    |> Enum.filter( fn(post) ->
      post.likes_count >= Math.median &&
      post.reposts_count >= Math.median(:reposts_count)
    end)
    IO.puts "Out: #{length(res)}"
    res
  end
end
