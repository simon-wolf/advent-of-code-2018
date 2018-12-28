defmodule TreeNode do
  defstruct child_nodes: [], metadata: [], sum: 0, value: 0, child_count: 0, metadata_length: 0, scratchpad: []
end

defmodule AdventOfCode2018.Day08 do
  @moduledoc false

  @doc """
  --- Day 8: Memory Maneuver ---

  The sleigh is much easier to pull than you'd expect for something its weight.
  Unfortunately, neither you nor the Elves know which way the North Pole is
  from here.

  You check your wrist device for anything that might help. It seems to have
  some kind of navigation system! Activating the navigation system produces
  more bad news: "Failed to start navigation system. Could not read software
  license file."

  The navigation system's license file consists of a list of numbers (your
  puzzle input). The numbers define a data structure which, when processed,
  produces some kind of tree that can be used to calculate the license number.

  The tree is made up of nodes; a single, outermost node forms the tree's root,
  and it contains all other nodes in the tree (or contains nodes that contain
  nodes, and so on).

  Specifically, a node consists of:

  - A header, which is always exactly two numbers:
  - The quantity of child nodes.
  - The quantity of metadata entries.
  - Zero or more child nodes (as specified in the header).
  - One or more metadata entries (as specified in the header).
  - Each child node is itself a node that has its own header, child nodes, and
    metadata. For example:

  2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2
  A----------------------------------
      B----------- C-----------
                      D-----

  In this example, each node of the tree is also marked with an underline
  starting with a letter for easier identification. In it, there are four
  nodes:

  A, which has 2 child nodes (B, C) and 3 metadata entries (1, 1, 2).
  B, which has 0 child nodes and 3 metadata entries (10, 11, 12).
  C, which has 1 child node (D) and 1 metadata entry (2).
  D, which has 0 child nodes and 1 metadata entry (99).

  The first check done on the license file is to simply add up all of the
  metadata entries. In this example, that sum is 1+1+2+10+11+12+2+99=138.

  What is the sum of all metadata entries?
  """
  def part1(file_path) do
    file_path
    |> File.read!()
    |> String.split()
    |> Enum.map(&String.to_integer/1)
    |> parse_data()
    |> Map.get(:sum)
  end

  @doc """
  The second check is slightly more complicated: you need to find the value of
  the root node (A in the example above).

  The value of a node depends on whether it has child nodes.

  If a node has no child nodes, its value is the sum of its metadata entries.
  So, the value of node B is 10+11+12=33, and the value of node D is 99.

  However, if a node does have child nodes, the metadata entries become
  indexes which refer to those child nodes. A metadata entry of 1 refers to the
  first child node, 2 to the second, 3 to the third, and so on. The value of
  this node is the sum of the values of the child nodes referenced by the
  metadata entries. If a referenced child node does not exist, that reference
  is skipped. A child node can be referenced multiple time and counts each time
  it is referenced. A metadata entry of 0 does not refer to any child node.

  For example, again using the above nodes:

  - Node C has one metadata entry, 2. Because node C has only one child node,
    2 references a child node which does not exist, and so the value of node C
    is 0.
  - Node A has three metadata entries: 1, 1, and 2. The 1 references node A's
    first child node, B, and the 2 references node A's second child node, C.
    Because node B has a value of 33 and node C has a value of 0, the value of
    node A is 33+33+0=66.

  So, in this example, the value of the root node is 66.

  What is the value of the root node?
  """
  def part2(file_path) do
    file_path
    |> File.read!()
    |> String.split()
    |> Enum.map(&String.to_integer/1)
    |> parse_data()
    |> Map.get(:value)
  end

  # Where there are no child nodes it is a simple case of creating a new node
  # and populating it. This is returned to the calling instance of parse_data
  # and it becomes a child node in the overall tree.
  defp parse_data([0, metadata_length | tail]) do
    metadata_items = Enum.slice(tail, 0, metadata_length)

    new_node = %TreeNode{child_count: 0, metadata_length: metadata_length}
    |> Map.put(:metadata, metadata_items)
    |> Map.put(:sum, metadata_items |> Enum.sum())
    |> Map.put(:value, metadata_items |> Enum.sum())
    |> Map.put(:scratchpad, Enum.slice(tail, metadata_length..-1))
  end

  # If there are child nodes then:
  # 1. Create a new node which will be the parent of the children.
  # 2. Loop the requisite number of times to create the children and also to
  #    calculate the sum value.
  # 3. Complete the addditional fields for the parent node.
  defp parse_data([child_count, metadata_length | tail]) do
    parent_node = Enum.reduce(1..child_count, %TreeNode{child_count: child_count, metadata_length: metadata_length, scratchpad: tail}, fn _, tree_node ->
      child_node = parse_data(Map.get(tree_node, :scratchpad))

      tree_node
      |> Map.put(:scratchpad, Map.get(child_node, :scratchpad))
      |> Map.put(:child_nodes, [child_node] ++ Map.get(tree_node, :child_nodes))
      |> Map.put(:sum, Map.get(tree_node, :sum) + Map.get(child_node, :sum))
    end)
    
    scratchpad_items = Map.get(parent_node, :scratchpad)
    metadata_items = Enum.slice(scratchpad_items, 0, metadata_length)
    metadata_sum = metadata_items |> Enum.sum()

    parent_node = Map.put(parent_node, :sum, Map.get(parent_node, :sum) + metadata_sum)

    child_values_map = build_child_values_map(parent_node.child_nodes)
    new_value = Enum.reduce(metadata_items, 0, fn item_index, acc ->
      acc + Map.get(child_values_map, item_index, 0)
    end)

    parent_node
    |> Map.put(:value, new_value)
    |> Map.put(:metadata, metadata_items)
    |> Map.put(:scratchpad, Enum.slice(scratchpad_items, metadata_length..-1))
  end

  # Loop through each node's children and build a map with a counter as the 
  # key and the value field's value. This makes looking up the values from the 
  # parent node's metadata simple. The children have to be reversed because
  # when they are added to the parent, new children are prepended for 
  # performance.
  defp build_child_values_map(child_nodes) do
    child_nodes
    |> Enum.reverse
    |> Enum.reduce(%{}, fn child_node, child_values_map ->
      Map.put(child_values_map, map_size(child_values_map) + 1, child_node.value)
    end)
  end
end
