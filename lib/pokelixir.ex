defmodule Pokelixir do
  @moduledoc """
  This module:
  - Defines a pokelixir struct
  - Defines functions to read and write from cache PokelixirCache
  - Defines functions to read from the Pokemon API
  -- Read a single pokemon - get_by_name/1
  -- Retreive all pokemons - all/0

  """

  defstruct [
    :id,
    :name,
    :hp,
    :attack,
    :defense,
    :special_attack,
    :special_defense,
    :speed,
    :height,
    :weight,
    :types,
    :abilities
  ]

  @type pokelixir() :: Pokelixir

  @doc """

  get_by_name/1

  Checks if the pokemon is already in the cache and retreives it if it exists.
  If not, makes a call to the Pokemon API and compiles the data into a %Pokelixir struct, which is then stored in the cache

  It calls private function get_from_api/1 and PokelixirCache.get/1 to get the information about a given pokemon name


  ## Examples

  iex> Pokelixir.get_by_name("charizard")
  %Pokelixir{
  id: 6,
  name: "charizard",
  hp: 78,
  attack: 84,
  defense: 78,
  special_attack: 109,
  special_defense: 85,
  speed: 100,
  height: 17,
  weight: 905,
  types: ["fire", "flying"],
  abilities: [
    %{
      description: "Strengthens fire moves to inflict 1.5├ù damage at 1/3 max HP or less.",
      name: "blaze"
    },
    %{
      description: "Increases Special Attack to 1.5├ù but costs 1/8 max HP after each turn during strong sunlight.",
      name: "solar-power"
    }
  ]
  }

  """

  @spec get_by_name(any) :: pokelixir()
  def get_by_name(name) do
    case PokelixirCache.get(name) do
      nil ->
        with pokemon <- get_from_api(name) do
          PokelixirCache.put(pokemon)
          pokemon
        end

      pokemon ->
        pokemon
    end
  end

  @spec get_from_api(String.t()) :: pokelixir()
  defp get_from_api(name) do
    HTTPoison.get("https://pokeapi.co/api/v2/pokemon/#{name}")
    |> decode_response()
    |> to_struct()
  end

  @doc """

  all/1 gets a list of Pokelixir structs of all pokemon

  The function makes a first call to the API to retreive the total number of pokemons.
  Then it populates a local cache of pokemons

  """
  @spec all() :: list()
  def all() do
    get_all_names() |> Enum.map(&get_by_name(&1))
  end

  @spec get_all_names() :: list()
  defp get_all_names() do
    map_of_all_pokemons = pokemon_count() |> get_all_pokemons()
    Enum.map(map_of_all_pokemons["results"], fn pokemon -> pokemon["name"] end)
  end

  @spec pokemon_count() :: integer()
  defp pokemon_count() do
    first_response =
      HTTPoison.get("https://pokeapi.co/api/v2/pokemon?offset=0&limit=1") |> decode_response()

    first_response["count"]
  end

  @spec get_all_pokemons(integer()) :: map()
  defp get_all_pokemons(total) do
    HTTPoison.get("https://pokeapi.co/api/v2/pokemon?offset=0&limit=#{total}")
    |> decode_response()
  end

  @doc """

  to_struct/1 takes the decoded map from Poison.decode! and returns a populated Pokelixir struct

  To achieve this, it makes use of private functions:
  - extract_stat/2, which returns the numerical value associated with the second argument passed ("attack", "defense"...)
  - extract_feature/2, which returns a list of features, retrieved by passing "type" or "ability".

  When retrieving abilities, there will be a call to the PokelixirDescriptions module, which makes an additional API call


  """

  @spec to_struct(map) :: pokelixir()
  def to_struct(decoded_map) do
    stats = decoded_map["stats"]

    %Pokelixir{
      id: decoded_map["id"],
      name: decoded_map["name"],
      hp: extract_stat(stats, "hp"),
      attack: extract_stat(stats, "attack"),
      defense: extract_stat(stats, "defense"),
      special_attack: extract_stat(stats, "special-attack"),
      special_defense: extract_stat(stats, "special-defense"),
      speed: extract_stat(stats, "speed"),
      height: decoded_map["height"],
      weight: decoded_map["weight"],
      types: extract_feature(decoded_map["types"], "type"),
      abilities: extract_feature(decoded_map["abilities"], "ability")
    }
  end

  @doc """

  decode_response/1 returns the JSON "body" of the API response

  """

  @spec decode_response(tuple()) :: map()
  def decode_response({:ok, response}), do: response.body |> Poison.decode!()

  @spec extract_feature(list(), String.t()) :: list()
  defp extract_feature(list_of_features, feature) do
    case feature do
      "type" ->
        Enum.map(list_of_features, &get_in(&1, [feature, "name"]))

      "ability" ->
        Enum.map(list_of_features, fn each ->
          %{
            name: get_in(each, [feature, "name"]),
            description: get_in(each, [feature, "url"]) |> PokelixirDescriptions.get_description()
          }

          # ,
          # changes:
        end)
    end
  end

  @spec extract_stat(list(), String.t()) :: integer()
  defp extract_stat(pokemon_stats, request) do
    hd(Enum.filter(pokemon_stats, &(get_in(&1, ["stat", "name"]) == request)))["base_stat"]
  end
end
