defmodule AdventOfCode2018.Day02 do
  @moduledoc false

  @doc """
  --- Day 2: Inventory Management System ---

  You stop falling through time, catch your breath, and check the screen on
  the device. "Destination reached. Current Year: 1518. Current Location:
  North Pole Utility Closet 83N10." You made it! Now, to find those anomalies.

  Outside the utility closet, you hear footsteps and a voice. "...I'm not sure
  either. But now that so many people have chimneys, maybe he could sneak in
  that way?" Another voice responds, "Actually, we've been working on a new
  kind of suit that would let him fit through tight spaces like that. But, I
  heard that a few days ago, they lost the prototype fabric, the design plans,
  everything! Nobody on the team can even seem to remember important details
  of the project!"

  "Wouldn't they have had enough fabric to fill several boxes in the warehouse?
  They'd be stored together, so the box IDs should be similar. Too bad it would
  take forever to search the warehouse for two similar box IDs..." They walk
  too far away to hear any more.

  Late at night, you sneak to the warehouse - who knows what kinds of paradoxes
  you could cause if you were discovered - and use your fancy wrist device to
  quickly scan every box and produce a list of the likely candidates (your
  puzzle input).

  To make sure you didn't miss any, you scan the likely candidate boxes again,
  counting the number that have an ID containing exactly two of any letter and
  then separately counting those with exactly three of any letter. You can
  multiply those two counts together to get a rudimentary checksum and compare
  it to what your device predicts.

  For example, if you see the following box IDs:

  abcdef contains no letters that appear exactly two or three times.
  bababc contains two a and three b, so it counts for both.
  abbcde contains two b, but no letter appears exactly three times.
  abcccd contains three c, but no letter appears exactly two times.
  aabcdd contains two a and two d, but it only counts once.
  abcdee contains two e.
  ababab contains three a and three b, but it only counts once.

  Of these box IDs, four of them contain a letter which appears exactly twice,
  and three of them contain a letter which appears exactly three times.
  Multiplying these together produces a checksum of 4 * 3 = 12.

  What is the checksum for your list of box IDs?
  """
  def part1(file_path) do
    {twos, threes} = file_path
    |> File.stream!()
    |> Stream.map(&String.trim/1)
		|> Enum.to_list()
		|> Enum.map(&letters_map/1)
    |> Enum.reduce({0, 0}, fn map, {tw, th} ->
      new_tw = if Map.has_key?(map, 2), do: tw + 1, else: tw
      new_th = if Map.has_key?(map, 3), do: th + 1, else: th
      {new_tw, new_th}
    end)

    twos * threes
  end

  defp letters_map(letters) do
		letters
		|> String.graphemes()
		|> Enum.reduce(%{}, fn char, acc ->
			Map.update(acc, char, 1, &(&1 + 1))
    end)
    |> Enum.into(%{}, fn {key, value} ->
      {value, key}
    end)
	end

  @doc """
  Confident that your list of box IDs is complete, you're ready to find the
  boxes full of prototype fabric.

  The boxes will have IDs which differ by exactly one character at the same
  position in both strings. For example, given the following box IDs:

  abcde
  fghij
  klmno
  pqrst
  fguij
  axcye
  wvxyz

  The IDs abcde and axcye are close, but they differ by two characters (the
  second and fourth). However, the IDs fghij and fguij differ by exactly one
  character, the third (h and u). Those must be the correct boxes.

  What letters are common between the two correct box IDs? (In the example
  above, this is found by removing the differing character from either ID,
  producing fgij.)
  """
  def part2(file_path) do
    word_list = file_path
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Enum.to_list()

    # words_length = Enum.reduce(word_list, 0, fn word ->
    #   String.length(word)
    # end)
    # IO.inspect words_length

    pairings = for word_a <- word_list, word_b <- word_list, word_a != word_b, do: {word_a, word_b}

    Enum.reduce_while(pairings, nil, fn {word_a, word_b}, _ ->
      matches = matched_letters(word_a, word_b)
      if String.length(matches) == 26, do: {:halt, matches}, else: {:cont, word_a}
    end)
  end

  def matched_letters(word_1, word_2) do
    compare_words(word_1, word_2)
    |> count_character_matches()
    |> List.to_string()
  end

  defp count_character_matches(character_list) do
    Enum.reduce(character_list, [], fn character, matches ->
      if character != "" do
        matches ++ [character]
      else
        matches
      end
    end)
  end

  defp compare_words(word_1, word_2) do
    String.graphemes(word_1)
    |> Enum.reduce([], fn character, matches ->
      matches ++ matching_character(character, String.at(word_2, length(matches)))
    end)
  end

  defp matching_character(character_1, character_2) when character_1 == character_2, do: [character_1]
  defp matching_character(_, _), do: [""]

end
