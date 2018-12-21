defmodule AdventOfCode2018.Day14 do
  @moduledoc false

  @doc """
  --- Day 14: Chocolate Charts ---

  You finally have a chance to look at all of the produce moving around. 
  Chocolate, cinnamon, mint, chili peppers, nutmeg, vanilla... the Elves must 
  be growing these plants to make hot chocolate! As you realize this, you hear 
  a conversation in the distance. When you go to investigate, you discover two 
  Elves in what appears to be a makeshift underground kitchen/laboratory.

  The Elves are trying to come up with the ultimate hot chocolate recipe; 
  they're even maintaining a scoreboard which tracks the quality score (0-9) 
  of each recipe.

  Only two recipes are on the board: the first recipe got a score of 3, the 
  second, 7. Each of the two Elves has a current recipe: the first Elf starts 
  with the first recipe, and the second Elf starts with the second recipe.

  To create new recipes, the two Elves combine their current recipes. This 
  creates new recipes from the digits of the sum of the current recipes' 
  scores. With the current recipes' scores of 3 and 7, their sum is 10, and so 
  two new recipes would be created: the first with score 1 and the second with 
  score 0. If the current recipes' scores were 2 and 3, the sum, 5, would only 
  create one recipe (with a score of 5) with its single digit.

  The new recipes are added to the end of the scoreboard in the order they are 
  created. So, after the first round, the scoreboard is 3, 7, 1, 0.

  After all new recipes are added to the scoreboard, each Elf picks a new 
  current recipe. To do this, the Elf steps forward through the scoreboard a 
  number of recipes equal to 1 plus the score of their current recipe. So, 
  after the first round, the first Elf moves forward 1 + 3 = 4 times, while the 
  second Elf moves forward 1 + 7 = 8 times. If they run out of recipes, they 
  loop back around to the beginning. After the first round, both Elves happen 
  to loop around until they land on the same recipe that they had in the 
  beginning; in general, they will move to different recipes.

  Drawing the first Elf as parentheses and the second Elf as square brackets, 
  they continue this process:

  (3)[7]
  (3)[7] 1  0 
  3  7  1 [0](1) 0 
  3  7  1  0 [1] 0 (1)
  (3) 7  1  0  1  0 [1] 2 
  3  7  1  0 (1) 0  1  2 [4]
  3  7  1 [0] 1  0 (1) 2  4  5 
  3  7  1  0 [1] 0  1  2 (4) 5  1 
  3 (7) 1  0  1  0 [1] 2  4  5  1  5 
  3  7  1  0  1  0  1  2 [4](5) 1  5  8 
  3 (7) 1  0  1  0  1  2  4  5  1  5  8 [9]
  3  7  1  0  1  0  1 [2] 4 (5) 1  5  8  9  1  6 
  3  7  1  0  1  0  1  2  4  5 [1] 5  8  9  1 (6) 7 
  3  7  1  0 (1) 0  1  2  4  5  1  5 [8] 9  1  6  7  7 
  3  7 [1] 0  1  0 (1) 2  4  5  1  5  8  9  1  6  7  7  9 
  3  7  1  0 [1] 0  1  2 (4) 5  1  5  8  9  1  6  7  7  9  2 
  
  The Elves think their skill will improve after making a few recipes (your 
  puzzle input). However, that could take ages; you can speed this up 
  considerably by identifying the scores of the ten recipes after that. For 
  example:

  - If the Elves think their skill will improve after making 9 recipes, the 
    scores of the ten recipes after the first nine on the scoreboard would be 
    5158916779 (highlighted in the last line of the diagram).
  - After 5 recipes, the scores of the next ten would be 0124515891.
  - After 18 recipes, the scores of the next ten would be 9251071085.
  - After 2018 recipes, the scores of the next ten would be 5941429882.

  What are the scores of the ten recipes immediately after the number of 
  recipes in your puzzle input?

  Your puzzle input is 894501.
  """
  def part1(recipie_count) do
    elf_1_index = 0
    elf_2_index = 1
    scores = "37"

    next_scores(elf_1_index, elf_2_index, scores, String.length(scores), recipie_count + 10)
  end

  defp next_scores(elf_1_index, elf_2_index, scores, scores_length, target_length) when scores_length > target_length do
    String.slice(scores, target_length - 10, 10)
  end

  defp next_scores(elf_1_index, elf_2_index, scores, scores_length, target_length) do
    elf_1_score = String.at(scores, elf_1_index) |> String.to_integer
    elf_2_score = String.at(scores, elf_2_index) |> String.to_integer
    scores = scores <> Integer.to_string(elf_1_score + elf_2_score)

    elf_1_index = rem(elf_1_score + 1 + elf_1_index, String.length(scores))
    elf_2_index = rem(elf_2_score + 1 + elf_2_index, String.length(scores))
    
    next_scores(elf_1_index, elf_2_index, scores, String.length(scores), target_length)
  end

  def part2(recipie_count) do
  end

  

  def part0(recipie_count) do
    stream = recipe_stream 3, 7
    stream
    |> Stream.drop(recipie_count)
    |> Stream.take(10)
    |> Enum.to_list
    |> Enum.map(&(&1 + ?0))
    |> List.to_string
  end

  defp recipe_stream recipe1, recipe2 do
    recipes = <<recipe1, recipe2>>
    acc = {recipes, {0, 1}, [recipe1, recipe2]}
    Stream.unfold(acc, &get_next_recipe/1)
  end

  defp get_next_recipe acc do
    case acc do
      {recipes, cur, [h | t]} ->
        {h, {recipes, cur, t}}
      {recipes, cur, []} ->
        get_next_recipe(build_more_recipes(recipes, cur))
    end
  end

  defp build_more_recipes recipes, {cur1, cur2} do
    next = :binary.at(recipes, cur1) + :binary.at(recipes, cur2)
    new_recipes = Enum.map(Integer.to_charlist(next), &(&1 - ?0))
    recipes = <<recipes::binary, :erlang.list_to_binary(new_recipes)::binary>>
    size = byte_size recipes
    cur1 = rem(cur1 + 1 + :binary.at(recipes, cur1), size)
    cur2 = rem(cur2 + 1 + :binary.at(recipes, cur2), size)
    {recipes, {cur1, cur2}, new_recipes}
  end

end
