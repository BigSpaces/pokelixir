# Welcome to Pokelixir

![image](https://media.giphy.com/media/fSvqyvXn1M3btN8sDh/giphy-downsized.gif)

This Mix application is a student project, designed by Elixir Jedi Master [@BrooklinJazz](https://github.com/BrooklinJazz), director of [Dockyard Academy](https://academy.dockyard.com).

The purpose of the exercise is to put together the knowledge absorbed during first half of the curriculum. Students who surviv... erm, complete the assignment, prove some understanding and use of:
- Elixir (of course)
- Data types
- ETP
- Caching
- APIs
- GenServers
- Testing
- Mix projects
- Supervision trees
- Documentation
- GitHub
- Patience, perseverance, and a bit of coffee here and there.


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `pokelixir` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:pokelixir, "~> 0.1.0"}
  ]
end
```

Extensive documentation (a couple of paragraphs so far) can be found at <https://hexdocs.pm/pokelixir>.


### Features

Get your daily API dopamine hit by retrieving basic information about a pokemon. Pass your preferred pokemon's name to the function `Pokelixir.get_by_name/1`. The data is stored in a ´%Pokelixir{}´ struct.

Alternatively, you may populate your local cache with all of the pokemons available through the API. Use ´Pokelixir.all()´. Delight in knowing that it is all happening under the careful supervision of a... supervisor.

Only a selected number of fields are parsed for each pokemon.


### Enjoy!

![image](https://media.giphy.com/media/LxSFsOTa3ytEY/giphy.gif)
