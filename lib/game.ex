defmodule ElixTacToe.Game do
  alias ElixTacToe.Game

  defstruct board: {nil,nil,nil,nil,nil,nil,nil,nil,nil},
            marker: :x,
            winner: nil,
            is_finished?: false

  # 0 1 2
  # 3 4 5
  # 6 7 8
  
  @vertical_indices [
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8]
  ]

  @horizontal_indices [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8]
  ]

  @diagonal_indices [
    [0, 4, 8],
    [2, 4, 6]
  ]

  def place_marker(%Game{is_finished?: true}), do: {:error, :game_already_over}
  def place_marker(game = %Game{board: board, marker: marker}, square) when is_nil elem(board, square) do
    {
      :ok,
        game
        |> Map.put(:board, put_elem(board, square, marker))
        |> Game.check_end_of_game
        |> Game.switch_player
    }
  end

  def place_marker(_game = %Game{}, _invalid) do
    {:error, :invalid_square}
  end

  def check_end_of_game(game = %Game{}) do
    game
    |> check_victory(:x)
    |> check_victory(:o)
    |> check_tie
  end

  def check_victory(game = %Game{is_finished?: true}, _marker), do: game
  def check_victory(game = %Game{}, marker) do
    game
    |> check_indices(@horizontal_indices, marker)
    |> check_indices(@vertical_indices, marker)
    |> check_indices(@diagonal_indices, marker)
  end

  def check_indices(game = %Game{is_finished?: true}, _indices, _marker), do: game
  def check_indices(game = %Game{board: board}, indices, marker) do
    if has_winner?(board, indices, marker) do
      %Game{game| winner: marker, is_finished?: true}
    else
      game
    end
  end

  def has_winner?(board, winning_indices, marker) do
    Enum.any?(winning_indices, fn indices ->
      Enum.all?(indices, fn index -> elem(board, index) == marker end)
    end)
  end

  def check_tie(game = %Game{is_finished?: true}), do: game
  def check_tie(game = %Game{}) do
    case squares_left(game.board) do
      0 -> %Game{game | is_finished?: true}
      _ -> game
    end
  end

  def squares_left(board) do
    board
    |> Tuple.to_list
    |> Enum.filter(fn square -> square == nil end)
    |> Enum.count
  end

  def switch_player(game = %Game{is_finished?: true}), do: game
  def switch_player(game = %Game{is_finished?: false, marker: marker}), do: %Game{game | marker: next_player(marker)}

  defp next_player(:x), do: :o
  defp next_player(:o), do: :x
    
end
