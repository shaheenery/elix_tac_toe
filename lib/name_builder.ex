defmodule ElixTacToe.NameBuilder do
  @moduledoc """
  Provides easy read/type/remember game names.
  """

  @doc """
  Generates a unique, URL-friendly name such as "bold-frog-8049".
  """
  def generate do
    [
      Enum.random(adjectives()),
      Enum.random(nouns()),
      :rand.uniform(9999)
    ]
    |> Enum.join("-")
  end

  defp adjectives do
    ~w(
      smiley happy silly cute teeny tiny adorable splendid
      shiny glittery peppy kawaii giddy heroic delicate sweet
    )
  end

  defp nouns do
    ~w(
      puppy unicorn dragon bear basket flower apple pony firefly
      garlic kitten tshirt sock hamper piglet corgi doll
      toy lunchbox hero treats candy puglet frenchie jerry fairy
      shenanigans
      )
  end

end
