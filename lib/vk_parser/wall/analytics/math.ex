defmodule VkParser.Wall.Analytics.Math do

  def median(column \\ :likes_count) do
    VkParser.Wall.PostsStorage.state 
    |> Enum.map(&(Map.get(&1, column)))
    |> Statistics.median
  end

  def mean(column \\ :likes_count) do
    VkParser.Wall.PostsStorage.state 
    |> Enum.map(&(Map.get(&1, column)))
    |> Statistics.mean
  end

  def variance(column \\ :likes_count) do
    VkParser.Wall.PostsStorage.state 
    |> Enum.map(&(Map.get(&1, column)))
    |> Statistics.mean
  end
end
