defmodule ElixTacToe.UI.CommandLine do

  alias ElixTacToe.{Game, GameSupervisor, NameBuilder, Server}

  def start do
    name = NameBuilder.generate
    GameSupervisor.start_game(name)
    introductions(name)
  end

  def introductions(game_name) do
    x_player = IO.gets("Player One, What is your name?\n") |> String.trim
    o_player = IO.gets("Player Two, What is your name?\n") |> String.trim
    names = %{x: x_player, o: o_player}

    IO.puts "\nAll right #{names.x} and #{names.o}, lets keep it civil."
    IO.puts names.x <> " will be X's"
    IO.puts names.o <> " will be O's"
    play(game_name, names)
  end

  def play(game_name, names) do
    game = Server.game(game_name)
    print_game(game)
    case game.is_finished? do
      false ->
        move = prompt_move(game, names)

        case Server.place_marker(game_name, move) do
          {:error, msg} ->
            print_error(msg)
          _ -> true
        end

        play(game_name, names)
      true ->
        print_summary(game, names)
    end

  end

  def print_game(game) do
    print_board(game.board)
  end

  def print_error(msg) do
    IO.puts "Whoa whoa whoa, it looks like you tried to #{msg}"
  end

  def prompt_move(game, names) do
    prompt = "Ok #{current_player(names, game.marker)}, where would you like to go? "
    entry = IO.gets(prompt)
    case Integer.parse(entry) do
      {square, "\n"} -> square
      :error ->
        IO.puts "Quit fecking around"
        prompt_move(game, names)
    end
  end

  def current_player(names, marker) do
    Map.get(names, marker)
  end

  def print_summary(%Game{winner: nil}, _names) do
    IO.puts "Oh great, a tie.  Good job."
  end

  def print_summary(%Game{winner: winner}, names) do
    winner = Map.get(names, winner)
    IO.puts "Congratulations #{winner}, you won!"
  end


  #    ╻   ╻
  #  X ┃ X ┃ X
  # ━━━╋━━━╋━━━
  #  X ┃ X ┃ X
  # ━━━╋━━━╋━━━
  #  X ┃ X ┃ X
  #    ╹   ╹

  def print_board(b) do
    ~s"""
       ╻   ╻
     #{m(b,0)} ┃ #{m(b,1)} ┃ #{m(b,2)}
    ━━━╋━━━╋━━━
     #{m(b,3)} ┃ #{m(b,4)} ┃ #{m(b,5)}
    ━━━╋━━━╋━━━
     #{m(b,6)} ┃ #{m(b,7)} ┃ #{m(b,8)}
       ╹   ╹
    """
    |> IO.puts
  end

  def m(board, index) do
    case elem(board, index) do
    nil -> index + 1
    :x -> "X"
    :o -> "O"
    end
  end

end
