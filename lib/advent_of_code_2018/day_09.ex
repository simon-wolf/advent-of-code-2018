defmodule Marble do
  @moduledoc false

  defstruct previous_key: 0, next_key: 0

  def take_turn(1, _current_key, _marbles_map) do
    marble_map = Map.new()
    marble_map = Map.put(marble_map, 0, %Marble{previous_key: 1, next_key: 1})
    marble_map = Map.put(marble_map, 1, %Marble{previous_key: 0, next_key: 0})
    {1, marble_map, 0}
  end

  def take_turn(turn_number, current_key, marbles_map) when rem(turn_number, 23) == 0 do
    score = turn_number

    marble_to_remove_key = Enum.reduce(1..7, current_key, fn _, key_number ->
      current_marble = Map.get(marbles_map, key_number)
      previous_marble_key = Map.get(current_marble, :previous_key)
      previous_marble_key
    end)

    marble_to_remove = Map.get(marbles_map, marble_to_remove_key)
    previous_key = Map.get(marble_to_remove, :previous_key)
    next_key = Map.get(marble_to_remove, :next_key)
    score = score + marble_to_remove_key

    previous_marble = Map.get(marbles_map, previous_key)
    new_previous_marble = Map.put(previous_marble, :next_key, next_key)

    next_marble = Map.get(marbles_map, next_key)
    new_next_marble = Map.put(next_marble, :previous_key, previous_key)

    new_marbles_map = marbles_map
    |> Map.delete(marble_to_remove_key)
    |> Map.put(previous_key, new_previous_marble)
    |> Map.put(next_key, new_next_marble)

    {next_key, new_marbles_map, score}
  end

  def take_turn(turn_number, current_key, marbles_map) do
    current_marble = Map.get(marbles_map, current_key)
    next_marble_key = Map.get(current_marble, :next_key)
    next_marble = Map.get(marbles_map, next_marble_key)
    tail_marble_key = Map.get(next_marble, :next_key)
    tail_marble = Map.get(marbles_map, tail_marble_key)

    new_marble = %Marble{previous_key: next_marble_key, next_key: tail_marble_key}

    new_next_marble = Map.put(next_marble, :next_key, turn_number)

    new_tail_marble = Map.put(tail_marble, :previous_key, turn_number)

    new_marbles_map = marbles_map
    |> Map.put(next_marble_key, new_next_marble)
    |> Map.put(turn_number, new_marble)
    |> Map.put(tail_marble_key, new_tail_marble)

    {turn_number, new_marbles_map, 0}
  end

end

defmodule AdventOfCode2018.Day09 do
  @moduledoc false

  @doc """
  --- Day 9: Marble Mania ---

  You talk to the Elves while you wait for your navigation system to 
  initialize. To pass the time, they introduce you to their favorite marble 
  game.

  The Elves play this game by taking turns arranging the marbles in a circle 
  according to very particular rules. The marbles are numbered starting with 
  0 and increasing by 1 until every marble has a number.

  First, the marble numbered 0 is placed in the circle. At this point, while 
  it contains only a single marble, it is still a circle: the marble is both 
  clockwise from itself and counter-clockwise from itself. This marble is 
  designated the current marble.

  Then, each Elf takes a turn placing the lowest-numbered remaining marble 
  into the circle between the marbles that are 1 and 2 marbles clockwise of 
  the current marble. (When the circle is large enough, this means that there 
  is one marble between the marble that was just placed and the current 
  marble.) The marble that was just placed then becomes the current marble.

  However, if the marble that is about to be placed has a number which is a 
  multiple of 23, something entirely different happens. First, the current 
  player keeps the marble they would have placed, adding it to their score. In 
  addition, the marble 7 marbles counter-clockwise from the current marble is 
  removed from the circle and also added to the current player's score. The 
  marble located immediately clockwise of the marble that was removed becomes 
  the new current marble.

  For example, suppose there are 9 players. After the marble with value 0 is 
  placed in the middle, each player (shown in square brackets) takes a turn. 
  The result of each of those turns would produce circles of marbles like 
  this, where clockwise is to the right and the resulting current marble is in 
  parentheses:

  [-] (0)
  [1]  0 (1)
  [2]  0 (2) 1 
  [3]  0  2  1 (3)
  [4]  0 (4) 2  1  3 
  [5]  0  4  2 (5) 1  3 
  [6]  0  4  2  5  1 (6) 3 
  [7]  0  4  2  5  1  6  3 (7)
  [8]  0 (8) 4  2  5  1  6  3  7 
  [9]  0  8  4 (9) 2  5  1  6  3  7 
  [1]  0  8  4  9  2(10) 5  1  6  3  7 
  [2]  0  8  4  9  2 10  5(11) 1  6  3  7 
  [3]  0  8  4  9  2 10  5 11  1(12) 6  3  7 
  [4]  0  8  4  9  2 10  5 11  1 12  6(13) 3  7 
  [5]  0  8  4  9  2 10  5 11  1 12  6 13  3(14) 7 
  [6]  0  8  4  9  2 10  5 11  1 12  6 13  3 14  7(15)
  [7]  0(16) 8  4  9  2 10  5 11  1 12  6 13  3 14  7 15 
  [8]  0 16  8(17) 4  9  2 10  5 11  1 12  6 13  3 14  7 15 
  [9]  0 16  8 17  4(18) 9  2 10  5 11  1 12  6 13  3 14  7 15 
  [1]  0 16  8 17  4 18  9(19) 2 10  5 11  1 12  6 13  3 14  7 15 
  [2]  0 16  8 17  4 18  9 19  2(20)10  5 11  1 12  6 13  3 14  7 15 
  [3]  0 16  8 17  4 18  9 19  2 20 10(21) 5 11  1 12  6 13  3 14  7 15 
  [4]  0 16  8 17  4 18  9 19  2 20 10 21  5(22)11  1 12  6 13  3 14  7 15 
  [5]  0 16  8 17  4 18(19) 2 20 10 21  5 22 11  1 12  6 13  3 14  7 15 
  [6]  0 16  8 17  4 18 19  2(24)20 10 21  5 22 11  1 12  6 13  3 14  7 15 
  [7]  0 16  8 17  4 18 19  2 24 20(25)10 21  5 22 11  1 12  6 13  3 14  7 15

  The goal is to be the player with the highest score after the last marble is 
  used up. Assuming the example above ends after the marble numbered 25, the 
  winning score is 23+9=32 (because player 5 kept marble 23 and removed marble 
  9, while no other player got any points in this very short example game).

  Here are a few more examples:

  10 players; last marble is worth 1618 points: high score is 8317
  13 players; last marble is worth 7999 points: high score is 146373
  17 players; last marble is worth 1104 points: high score is 2764
  21 players; last marble is worth 6111 points: high score is 54718
  30 players; last marble is worth 5807 points: high score is 37305

  What is the winning Elf's score?
  """
  def part1({player_count, last_marble_value}) do
    current_key = 0
    marbles_map = %{}

    {_current_key, _marbles_map, scores} = Enum.reduce(1..last_marble_value, {0, %{}, %{}}, fn turn, {current_key, marbles_map, scores} ->
      {new_current_key, new_marbles_map, score} = Marble.take_turn(turn, current_key, marbles_map)

      player = if rem(turn, player_count) == 0 do
        player_count
      else
        rem(turn, player_count)
      end

      old_score = Map.get(scores, player, 0)
      new_scores = Map.put(scores, player, old_score + score)

      {new_current_key, new_marbles_map, new_scores}
    end)

    scores
    |> Map.values()
    |> Enum.max()
  end

  @doc """
  Amused by the speed of your answer, the Elves are curious:

  What would the new winning Elf's score be if the number of the last marble 
  were 100 times larger?
  """
  def part2({player_count, last_marble_value}) do
    part1({player_count, last_marble_value * 100})
  end
end
