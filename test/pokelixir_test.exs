defmodule PokelixirTest do
  use ExUnit.Case
  doctest Pokelixir

  test "create a pokemon" do
    assert %Pokelixir{id: 1} == %Pokelixir{
             id: 1,
             name: nil,
             hp: nil,
             attack: nil,
             defense: nil,
             special_attack: nil,
             special_defense: nil,
             speed: nil,
             height: nil,
             weight: nil,
             types: nil,
             abilities: nil
           }
  end

  test "get_by_name/1" do
    assert Pokelixir.get_by_name("charizard") == %Pokelixir{
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
                 description:
                   "Strengthens fire moves to inflict 1.5├ù damage at 1/3 max HP or less.",
                 name: "blaze"
               },
               %{
                 description:
                   "Increases Special Attack to 1.5├ù but costs 1/8 max HP after each turn during strong sunlight.",
                 name: "solar-power"
               }
             ]
           }

    assert Pokelixir.get_by_name("bulbasaur") == %Pokelixir{
             id: 1,
             name: "bulbasaur",
             hp: 45,
             attack: 49,
             defense: 49,
             special_attack: 65,
             special_defense: 65,
             speed: 45,
             height: 7,
             weight: 69,
             types: ["grass", "poison"],
             abilities: [
               %{
                 description:
                   "Strengthens grass moves to inflict 1.5├ù damage at 1/3 max HP or less.",
                 name: "overgrow"
               },
               %{description: "Doubles Speed during strong sunlight.", name: "chlorophyll"}
             ]
           }
  end

  test "get_description/1" do
    assert PokelixirDescriptions.get_description("https://pokeapi.co/api/v2/ability/67/") ==
             "Strengthens water moves to inflict 1.5├ù damage at 1/3 max HP or less."
  end
end
