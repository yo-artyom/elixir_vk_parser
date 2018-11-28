defmodule VkParser.Wall.PostsStorage do
  @moduledoc """
  Genserver responsible for storage a group data returned from VK.
  """

  use GenServer

  alias VkParser.Wall.Post

  @doc """
  Starts the storage server
  """
  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @doc """
  Returns `[%Post{}]`
  """
  def state do
    GenServer.call(__MODULE__, :state)
  end

  @doc false
  def push(item = %Post{}) do
    GenServer.cast(__MODULE__, {:push, item})
  end

  @doc false
  def empty? do
    state() == []
  end

  @impl true
  def init(args) do
    {:ok, args}
  end

  @impl true
  def handle_cast({:push, item}, state) do
    {:noreply, [item | state]}
  end

  @impl true
  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end
end
