defmodule PokelixirCache do
  @moduledoc """

  This module is the first one to be initialized by the Pokelixir Application.app()
  The Supervision Tree starts the caching features of the app
  In this version, only pokemon structs are cached. Code is prepared to scale to handle caching of abilities and types.

  """

  use GenServer
  @table_pokemons :pokemon_cache
  # @table_abilities :abilities_cache

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

  @doc """
  Create a new ETS Cache if it doesn't already exists
  :ets.new(@table_abilities, [:set, :public, :named_table]) - Future implementation of abilities cache
  """

  @spec cache_init :: atom | :ets.tid()
  def cache_init do
    :ets.new(@table_pokemons, [:set, :public, :named_table])
  rescue
    ArgumentError -> {:error, :already_started}
  end

  @doc """
  Inserts a pokemon in the cache
  """

  def put(pokemon) do
    GenServer.cast(:pokelixir_cache, {:put, pokemon})
  end

  @doc """
  Retreive a value back from cache
  """

  def get(name) do
    GenServer.call(:pokelixir_cache, {:get, name})
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
