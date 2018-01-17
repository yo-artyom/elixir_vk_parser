defmodule VkParser.Wall.Analytics.ToCsv do
  @keys [:id, :likes_count, :repost_count]

  def call(filename \\ "downloads/result.csv") do
    file = File.open!(filename, [:write, :utf8])
    VkParser.Wall.PostsStorage.state
    |> Enum.map(&(make_row(&1)))
    |> CSV.encode
    |> Enum.each(&IO.write(file, &1))
  end

  defp make_row(row) do
    Enum.map(@keys, fn(key) ->
      Map.get(row, key)
    end)
  end
end
