defmodule ElixTacToe.GameSupervisor do
  @moduledoc """
  A supervisor that starts `GameServer` processes dynamically.
  """

  use DynamicSupervisor

  alias ElixTacToe.Server

  def start_link(_arg) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  @doc """
  Starts a `GameServer` process and supervises it.
  """
  def start_game(game_name) do
    child_spec = %{
      id: Server,
      start: {Server, :start_link, [game_name]},
      restart: :transient
    }

    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  @doc """
  Terminates the `GameServer` process normally. It won't be restarted.
  """
  def stop_game(game_name) do
    :ets.delete(:games_table, game_name)

    child_pid = Server.game_pid(game_name)
    DynamicSupervisor.terminate_child(__MODULE__, child_pid)
  end
end
