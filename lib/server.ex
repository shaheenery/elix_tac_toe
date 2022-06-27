defmodule ElixTacToe.Server do
  @moduledoc """
  A game server process that holds a `Game` struct as its state.
  """

  use GenServer

  require Logger

  alias ElixTacToe.{Game}

  @timeout :timer.hours(2)

  # Client (Public) Interface

  @doc """
  Spawns a new game server process registered under the given `game_name`.
  """
  def start_link(game_name) do
    GenServer.start_link(
      __MODULE__,
      game_name,
      name: via_tuple(game_name)
    )
  end

  # def summary(game_name) do
  #   GenServer.call(via_tuple(game_name), :summary)
  # end

  def game(game_name) do
    GenServer.call(via_tuple(game_name), :game)
  end

  def place_marker(game_name, square_index) do
    GenServer.call(via_tuple(game_name), {:place_marker, square_index})
  end

  # def take_color(game_name, player_id, location, color) do
  #   GenServer.call(via_tuple(game_name), {:take_color, player_id, location, color})
  # end

  # def place_hand(game_name, player_id, line_number) do
  #   GenServer.call(via_tuple(game_name), {:place_hand, player_id, line_number})
  # end

  # def take_and_place(game_name, player_id, location, color, line_number) do
  #   GenServer.call(
  #     via_tuple(game_name),
  #     {:take_and_place, player_id, location, color, line_number}
  #   )
  # end

  # # TODO
  # def mark(game_name, phrase, player) do
  #   GenServer.call(via_tuple(game_name), {:mark, phrase, player})
  # end

  @doc """
  Returns a tuple used to register and lookup a game server process by name.
  """
  def via_tuple(game_name) do
    {:via, Registry, {ElixTacToe.GameRegistry, game_name}}
  end

  @doc """
  Returns the `pid` of the game server process registered under the
  given `game_name`, or `nil` if no process is registered.
  """
  def game_pid(game_name) do
    game_name
    |> via_tuple()
    |> GenServer.whereis()
  end

  # Server Callbacks

  def init(game_name) do
    game =
      case :ets.lookup(:games_table, game_name) do
        [] ->
          game = %Game{}
          :ets.insert(:games_table, {game_name, game})
          game

        [{^game_name, game}] ->
          game
      end

    # Logger.info("Spawned game server process named '#{game_name}'.")

    {:ok, game}
  end

  # def handle_call(:summary, _from, {game, mapping}) do
  #   {:reply, summarize(game, mapping), {game, mapping}, @timeout}
  # end

  def handle_call(:game, _from, game) do
    {:reply, game, game, @timeout}
  end

  def handle_call({:place_marker, square_number}, _from, game) do
    case Game.place_marker(game, square_number - 1) do
      {:ok, after_placement} ->
        {:reply, after_placement, after_placement, @timeout}
      {:error, msg} ->
        {:reply, {:error, msg}, game, @timeout}
    end
  end

  # def handle_call({:take_color, player_id, location, color}, _from, {game, mapping}) do
  #   {_player, player_ord} = Map.get(mapping, player_id)

  #   case Azul.Game.take_color(game, player_ord, location, color) do
  #     {:error, msg} ->
  #       {:reply, {:error, msg}, {game, mapping}, @timeout}

  #     after_take ->
  #       AzulWeb.Endpoint.broadcast(my_topic(), "update", %{game: after_take})
  #       {:reply, after_take, {after_take, mapping}, @timeout}
  #   end
  # end

  # def handle_call({:place_hand, player_id, line_number}, _from, {game, mapping}) do
  #   {_player, player_ord} = Map.get(mapping, player_id)

  #   case Azul.Game.place_hand(game, player_ord, line_number) do
  #     {:error, msg} ->
  #       {:reply, {:error, msg}, {game, mapping}, @timeout}

  #     after_place ->
  #       AzulWeb.Endpoint.broadcast(my_topic(), "update", %{game: after_place})
  #       {:reply, after_place, {after_place, mapping}, @timeout}
  #   end
  # end

  # def handle_call(
  #       {:take_and_place, player_id, location, color, line_number},
  #       _from,
  #       {game, mapping}
  #     ) do
  #   {_player, player_ord} = Map.get(mapping, player_id)

  #   case Azul.Game.take_and_place(game, player_ord, location, color, line_number) do
  #     {:error, msg} ->
  #       {:reply, {:error, msg}, {game, mapping}, @timeout}

  #     after_place ->
  #       AzulWeb.Endpoint.broadcast(my_topic(), "update", %{game: after_place})
  #       {:reply, after_place, {after_place, mapping}, @timeout}
  #   end
  # end

  # def handle_continue(:send_game_started, state) do
  #   AzulWeb.Endpoint.broadcast("room:#{my_game_name()}", "game_started", %{})
  #   {:noreply, state}
  # end

  # TODO
  # def summarize(game, mapping) do
  #   {game, public_mapping(mapping)}
  # end

  def handle_info(:timeout, game) do
    {:stop, {:shutdown, :timeout}, game}
  end

  def terminate({:shutdown, :timeout}, _game) do
    :ets.delete(:games_table, my_game_name())
    :ok
  end

  def terminate(_reason, _game) do
    :ok
  end

  # defp public_mapping(mapping) do
  #   Enum.reduce(mapping, %{}, fn {_k, {player, ord}}, acc ->
  #     Map.put(acc, ord, Map.delete(player, :auth))
  #   end)
  # end

  defp my_game_name do
    Registry.keys(ElixTacToe.GameRegistry, self()) |> List.first()
  end

  # defp my_topic do
  #   "game:#{my_game_name()}"
  # end
end
