defmodule VkParser.Wall.Analytics.Math do

  def median(group, column \\ :likes_count) do
    VkParser.Wall.PostsStorage.state 
    |> Stream.filter( fn(post) -> post.group_name == group end)
    |> Enum.map(&(Map.get(&1, column)))
    |> Statistics.median
  end

  def mean(group, column \\ :likes_count) do
    VkParser.Wall.PostsStorage.state 
    |> Stream.filter( fn(post) -> post.group_name == group end)
    |> Enum.map(&(Map.get(&1, column)))
    |> Statistics.mean
  end

  def variance(group, column \\ :likes_count) do
    VkParser.Wall.PostsStorage.state 
    |> Stream.filter( fn(post) -> post.group_name == group end)
    |> Enum.map(&(Map.get(&1, column)))
    |> Statistics.mean
  end
end
