defmodule PokelixirCache do
  @moduledoc """

  This module handles:
  - initialization of the ETS cache tables - cache_init/0
  - putting pokemons into the cache - put/1
  - getting pokemons from the cache - get/1

  """


  @doc """
  Gets called by the PokelixirCacheServer at startup
  Creates a new ETS Cache if it doesn't already exists
  """
  @table_pokemons :pokemon_cache


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


end
