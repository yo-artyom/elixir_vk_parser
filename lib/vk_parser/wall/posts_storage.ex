defmodule VkParser.Wall.PostsStorage do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def push(item) do
    GenServer.cast(__MODULE__, {:push, item})
  end

  def state do
    GenServer.call(__MODULE__, :state)
  end

  def handle_cast({:push, item}, state) do
    {:noreply, [item | state ]}
  end

  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end
end
