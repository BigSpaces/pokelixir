defmodule PokelixirDescriptions do
  @moduledoc """

  This module deals with additional API calls.

  Currently it calls the endpoint for effects and retrieves a short description

  This layer of data is not cached at this point.


  Code is being drafted to access more information from the abilities endpoint (work in progress)

    ## Effect Changes Description
    # effect_changes = HTTPoison.get(url)
    #   |> Pokelixir.decode_response()
    #   |> get_in(["effect_changes"])
    #   |> hd()
    #   |> get_in(["effect_entries"])
    #   |> Enum.filter(&(get_in(&1, ["language", "name"]) == "en"))
    #   |> hd()

    # effect_changes["effect"]

  """

  @doc """
  This function returns the short description of a particular ability, based on passed URL

   ## Examples

  iex> PokelixirDescriptions.get_description("https://pokeapi.co/api/v2/ability/62/")
  "Increases Attack to 1.5├ù with a major status ailment."
  """

  @spec get_description(String.t()) :: String.t()
  def get_description(url) do
    ## Effect Entries Description

    effect_entries =
      HTTPoison.get(url) |> Pokelixir.decode_response() |> Map.get("effect_entries")

    case effect_entries do
      nil ->
        nil

      effect_entries ->
        effect_en = Enum.filter(effect_entries, &(get_in(&1, ["language", "name"]) == "en"))
        if effect_en == [], do: "No description available", else: hd(effect_en)["short_effect"]
    end
  end
end
