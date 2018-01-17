defmodule VkParser do
  @moduledoc """
  Application for downloading stuff from VK.

  ## Wall flow
  Module Wall responsible for stuff downloading from a group/public.
  """
  use Application

  alias VkParser.Wall.{PostsStorage, Reader, Downloader}

  @doc """
  Starts supervisor for PostsStorage 
  """
  def start(_t , _a) do
    import Supervisor.Spec, warn: false

    children = [worker(PostsStorage, [])]

    opts = [strategy: :one_for_one, name: VkParser.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @doc """
  Downloads all the media which is satisfy filters in downloads folder.

  At first, you need to fill database with responses from vk:
  `VkParser.Wall.Reader.WriteToDb.start`
  When parsing will be completed the callback will be called.
  """
  def start_wall_flow do
    Reader.WriteToDb.start_link( group(), posts_limit(), 
                                  &Downloader.Supervisor.start/0)
  end

  def group do
    {:ok, group } = Application.fetch_env(:vk_parser, :group)
    if group == nil, do: throw("You need to set up a group in the config!")
    group
  end

  def posts_limit do
    {:ok, limit } = Application.fetch_env(:vk_parser, :posts_limit)
    limit
  end

  def access_token do 
    case Application.fetch_env(:vk_parser, :access_token) do
      {:ok, nil } ->
        case check_access_token_file() do
          :not_found -> throw("Access token isn't setted")
          token -> token
        end
      {:ok, token} -> token
    end
  end

  defp check_access_token_file do
    case File.read(".access_token") do
      {:ok, token} ->
        token |> String.replace("\n", "")
      {:error, _ } -> :not_found
    end
  end
end
