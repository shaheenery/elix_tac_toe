defmodule ElixTacToe do
  @moduledoc """
  Documentation for `ElixTacToe`.
  """

  alias ElixTacToe.UI.{CommandLine}

  @doc """
  Hello world.

  ## Examples

      iex> ElixTacToe.hello()
      :world

  """
  def hello do
    :world
  end

  def play_command_line do
    CommandLine.start
  end
end
