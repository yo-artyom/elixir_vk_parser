defmodule VkParser.Wall.Filters.Images do
  @moduledoc """
    Selects only posts with the attachments
  """
  # TODO: rewrite filter and consumer ( make immutable )

  def filter(response) do
    response 
    |> Stream.filter(&(&1.attachments != nil)) 
    |> Enum.flat_map( fn(post) ->
      Enum.filter(post.attachments, &(&1["photo"] != nil)) 
      |> Enum.map(&(&1["photo"]))
    end)
  end
end
