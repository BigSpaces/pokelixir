defmodule PokelixirCacheServer do
  @moduledoc """

  This module is the first one to be initialized by the Pokelixir Application.app()
  The Supervision Tree starts the caching features of the app

  """

  use GenServer
  @table_pokemons :pokemon_cache

  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: :pokelixir_cache)
  end

  @impl true
  @spec init(any) :: {:ok, any}
  def init(init_arg) do
    PokelixirCache.cache_init()
    {:ok, init_arg}
  end

  @impl true
  def handle_cast({:put, pokemon}, _state) do
    IO.inspect(pokemon, label: "ETS PUT")
    true = :ets.insert(@table_pokemons, {pokemon.name, pokemon})
    {:noreply, :ok}
  end

  @impl true
  def handle_call({:get, name}, _from, _state) do
    IO.inspect(:ets.lookup(@table_pokemons, name), label: "ETS GET #{name}")

    case :ets.lookup(@table_pokemons, name) do
      [{^name, pokemon}] -> {:reply, pokemon, :ok}
      _else -> {:reply, nil, :ok}
    end
  end



end
