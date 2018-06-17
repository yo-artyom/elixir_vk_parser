defmodule VkParser do
  @moduledoc """
  Application for downloading stuff from VK.

  ## Wall flow
  Module Wall responsible for stuff downloading from groups.
  """
  use Application

  alias VkParser.Wall.{PostsStorage, Reader, Downloader}

  require IEx

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
    groups()
    |> Enum.each(fn(group_params) ->
      Reader.WriteToDb.start_link(group_params["name"],
                                  group_params["limit"], 
                                  group_params["offset"],
                                  &Downloader.Supervisor.start/0)
    end)
  end

  @doc """
  Read group params JSON file
  """
  def groups do
    {:ok, file } = File.read("config/group_params.json")
    file |> Poison.decode!
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
