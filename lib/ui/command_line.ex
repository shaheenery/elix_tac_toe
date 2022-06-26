defmodule ElixTacToe.UI.CommandLine do

  alias ElixTacToe.{GameSupervisor, NameBuilder, Server}

  def start do
    name = NameBuilder.generate
    GameSupervisor.start_game(name)
    introductions(name)
  end

  def introductions(game_name) do
    name1 = IO.gets("Player One, What is your name?\n") |> String.trim
    name2 = IO.gets("Player Two, What is your name?\n") |> String.trim
    IO.puts "\nAll right #{name1} and #{name2}, lets keep it civil."
    IO.puts name1 <> " will be X's"
    IO.puts name2 <> " will be O's"
    play(game_name, name1, name2)
  end

  def play(game_name, name1, name2) do
    game = Server.game(game_name)
    print_game(game)
  end

  def print_game(game) do
    print_board(game.board)
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
