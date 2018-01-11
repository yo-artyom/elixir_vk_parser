defmodule VkParser.Likes.GetLikes do
  @total VkParser.Likes.GetLikes

  def call(group, limit \\ 100000) do
    collect_likes(group, 0, limit)
    {:ok, VkParser.Likes.LikeStorage}
  end

  def collect_likes(group, offset, limit) when offset >= limit do
    VkParser.Likes.LikeStorage.state
  end

  def collect_likes(group, offset, limit) do
    spawn fn ->
      res = VkParser.VkApi.Wall.posts(group, offset)
      |> Enum.map(&(&1["likes"]["count"]))
      |> VkParser.Likes.LikeStorage.push
    end
    collect_likes(group, offset + 100, limit)
  end
end
