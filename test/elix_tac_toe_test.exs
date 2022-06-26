defmodule ElixTacToeTest do
  use ExUnit.Case
  doctest ElixTacToe

  test "greets the world" do
    assert ElixTacToe.hello() == :world
  end
end
