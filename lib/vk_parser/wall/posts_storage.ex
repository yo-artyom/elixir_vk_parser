defmodule VkParser.Wall.PostsStorage do
  @moduledoc """
  Genserver responsible for storing the group data returned from VK.
  Has structure of %{ group_name:  [%Post] }
  """
  use GenServer

  alias VkParser.Wall.Post

  def start_link do
    GenServer.start_link(__MODULE__, initial_state(), name: __MODULE__)
  end

  @doc """
  """
  def push(group, item = %Post{}) do
    GenServer.cast(__MODULE__, {:push, group, item})
  end

  def state do
    GenServer.call(__MODULE__, :state)
  end

  def empty? do
    state() == initial_state() 
  end

  def handle_cast({:push, group, item}, state) do
    {:noreply, %{ state | group => [item | state[group]] }}
  end

  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end

  defp initial_state do
    VkParser.groups 
    |> Enum.map( fn(group_params) ->
      group_params["name"]
    end)
    |> Map.new( fn(name) -> {name, []} end)
  end
end
