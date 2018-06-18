defmodule VkParser.Wall.PostsStorage do
  @moduledoc """
  Genserver responsible for storing the group data returned from VK.
  Has structure of %{ group_name:  [%Post] }
  """
  use GenServer

  alias VkParser.Wall.Post

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @doc """
  """
  def push(item = %Post{}) do
    GenServer.cast(__MODULE__, {:push, item})
  end

  def state do
    GenServer.call(__MODULE__, :state)
  end

  def empty? do
    state() == []
  end

  def handle_cast({:push, item}, state) do
    {:noreply, [item | state]}
  end

  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end
end
