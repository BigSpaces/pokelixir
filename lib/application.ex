defmodule Pokelixir.Application do
  use Application

  @impl true
  @spec start(any, any) :: {:error, any} | {:ok, pid}
  def start(_type, args) do
    IO.puts(args)
    children = [
     {PokelixirCache, "Cache started"}
    ]
    opts = [strategy: :one_for_one, name: Pokelixir.Supervisor]
      Supervisor.start_link(children, opts)
  end


end
