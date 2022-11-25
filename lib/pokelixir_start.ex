defmodule PokelixirStart do

  use GenServer

  @doc """

  start_link/1

  Starts the cache tables as part of the supervision tree of the Pokelixir application

  """

  def start_link(opts) do
    GenServer.start_link(PokelixirCache, opts, [])
  end

  def init(init_arg) do
    PokelixirCache.cache_init()
    {:ok, init_arg}
  end

end
