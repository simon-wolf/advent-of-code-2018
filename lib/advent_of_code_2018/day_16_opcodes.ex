defmodule AdventOfCode2018.Day16.Opcodes do
  @moduledoc false

  use Bitwise

  @doc """
  Stores into register C the result of adding register A and register B.

  ## Examples

      iex> AdventOfCode2018.Day16.Opcodes.addr(%{:A => 1, :B => 2, :C => 0})
      %{A: 1, B: 2, C: 3}
  """
  def addr(register) do
    Map.put(register, :C, Map.get(register, :A) + Map.get(register, :B))
  end

  @doc """
  Stores into register C the result of adding register A and value B.

  ## Examples

      iex> AdventOfCode2018.Day16.Opcodes.addi(%{:A => 1, :B => 0, :C => 0}, 2)
      %{A: 1, B: 0, C: 3}
  """
  def addi(register, b_value) when is_integer(b_value) do
    Map.put(register, :C, Map.get(register, :A) + b_value)
  end

  @doc """
  Stores into register C the result of multiplying register A and register B.

  ## Examples

      iex> AdventOfCode2018.Day16.Opcodes.mulr(%{:A => 2, :B => 3, :C => 0})
      %{A: 2, B: 3, C: 6}
  """
  def mulr(register) do
    Map.put(register, :C, Map.get(register, :A) * Map.get(register, :B))
  end

  @doc """
  Stores into register C the result of multiplying register A and value B.

  ## Examples

      iex> AdventOfCode2018.Day16.Opcodes.muli(%{:A => 3, :B => 0, :C => 0}, 4)
      %{A: 3, B: 0, C: 12}
  """
  def muli(register, b_value) when is_integer(b_value) do
    Map.put(register, :C, Map.get(register, :A) * b_value)
  end

  @doc """
  Stores into register C the result of the bitwise AND of register A and register B.

  ## Examples

      iex> AdventOfCode2018.Day16.Opcodes.banr(%{:A => 9, :B => 3, :C => 0})
      %{A: 9, B: 3, C: 1}
  """
  def banr(register) do
    Map.put(register, :C, Map.get(register, :A) &&& Map.get(register, :B))
  end

  @doc """
  Stores into register C the result of the bitwise AND of register A and value B.

  ## Examples

      iex> AdventOfCode2018.Day16.Opcodes.bani(%{:A => 9, :B => 0, :C => 0}, 3)
      %{A: 9, B: 0, C: 1}
  """
  def bani(register, b_value) when is_integer(b_value) do
    Map.put(register, :C, Map.get(register, :A) &&& b_value)
  end

  @doc """
  Stores into register C the result of the bitwise OR of register A and register B.

  ## Examples

      iex> AdventOfCode2018.Day16.Opcodes.borr(%{:A => 9, :B => 3, :C => 0})
      %{A: 9, B: 3, C: 11}
  """
  def borr(register) do
    Map.put(register, :C, bor(Map.get(register, :A), Map.get(register, :B)))
  end

  @doc """
  Stores into register C the result of the bitwise OR of register A and value B.

  ## Examples

      iex> AdventOfCode2018.Day16.Opcodes.bori(%{:A => 9, :B => 0, :C => 0}, 3)
      %{A: 9, B: 0, C: 11}
  """
  def bori(register, b_value) when is_integer(b_value) do
    Map.put(register, :C, bor(Map.get(register, :A), b_value))
  end

  @doc """
  Copies the contents of register A into register C. (Input B is ignored.)

  ## Examples

      iex> AdventOfCode2018.Day16.Opcodes.setr(%{:A => 9, :B => 3, :C => 0})
      %{A: 9, B: 3, C: 9}
  """
  def setr(register) do
    Map.put(register, :C, Map.get(register, :A))
  end

  @doc """
  Stores value A into register C. (Input B is ignored.)

  ## Examples

      iex> AdventOfCode2018.Day16.Opcodes.seti(%{:A => 9, :B => 3, :C => 0}, 5)
      %{A: 9, B: 3, C: 5}
  """
  def seti(register, a_value) when is_integer(a_value) do
    Map.put(register, :C, a_value)
  end

  




  @doc """
  Sets register C to 1 if value A is greater than register B. Otherwise, register C is set to 0.

  ## Examples

      iex> AdventOfCode2018.Day16.Opcodes.gtir(%{:A => 1, :B => 2, :C => 0}, 3)
      %{A: 1, B: 2, C: 1}

      iex> AdventOfCode2018.Day16.Opcodes.gtir(%{:A => 4, :B => 2, :C => 0}, 1)
      %{A: 4, B: 2, C: 0}

      iex> AdventOfCode2018.Day16.Opcodes.gtir(%{:A => 4, :B => 2, :C => 0}, 2)
      %{A: 4, B: 2, C: 0}
      
  """
  def gtir(register, a_value) when is_integer(a_value) do
    c_value = cond do
      a_value > Map.get(register, :B) -> 1
      true -> 0
    end
    Map.put(register, :C, c_value)
  end

  @doc """
  Sets register C to 1 if register A is greater than value B. Otherwise, register C is set to 0.

  ## Examples

      iex> AdventOfCode2018.Day16.Opcodes.gtri(%{:A => 9, :B => 10, :C => 0}, 8)
      %{A: 9, B: 10, C: 1}

      iex> AdventOfCode2018.Day16.Opcodes.gtri(%{:A => 9, :B => 8, :C => 0}, 10)
      %{A: 9, B: 8, C: 0}

      iex> AdventOfCode2018.Day16.Opcodes.gtri(%{:A => 9, :B => 9, :C => 0}, 9)
      %{A: 9, B: 9, C: 0}
      
  """
  def gtri(register, b_value) when is_integer(b_value) do
    c_value = cond do
      Map.get(register, :A) > b_value -> 1
      true -> 0
    end
    Map.put(register, :C, c_value)
  end

  @doc """
  Sets register C to 1 if register A is greater than register B. Otherwise, register C is set to 0.

  ## Examples

      iex> AdventOfCode2018.Day16.Opcodes.gtrr(%{:A => 9, :B => 8, :C => 0})
      %{A: 9, B: 8, C: 1}

      iex> AdventOfCode2018.Day16.Opcodes.gtrr(%{:A => 9, :B => 10, :C => 0})
      %{A: 9, B: 10, C: 0}

      iex> AdventOfCode2018.Day16.Opcodes.gtrr(%{:A => 9, :B => 9, :C => 0})
      %{A: 9, B: 9, C: 0}

  """
  def gtrr(register) do
    c_value = cond do
      Map.get(register, :A) > Map.get(register, :B) -> 1
      true -> 0
    end
    Map.put(register, :C, c_value)
  end

  @doc """
  Sets register C to 1 if value A is equal to register B. Otherwise, register C is set to 0.

  ## Examples

      iex> AdventOfCode2018.Day16.Opcodes.eqir(%{:A => 9, :B => 8, :C => 0}, 8)
      %{A: 9, B: 8, C: 1}

      iex> AdventOfCode2018.Day16.Opcodes.eqir(%{:A => 9, :B => 8, :C => 0}, 9)
      %{A: 9, B: 8, C: 0}

      iex> AdventOfCode2018.Day16.Opcodes.eqir(%{:A => 9, :B => 8, :C => 0}, 7)
      %{A: 9, B: 8, C: 0}

  """
  def eqir(register, a_value) when is_integer(a_value) do
    c_value = cond do
      a_value == Map.get(register, :B) -> 1
      true -> 0
    end
    Map.put(register, :C, c_value)
  end

  @doc """
  Sets register C to 1 if register A is equal to value B. Otherwise, register C is set to 0.

  ## Examples

      iex> AdventOfCode2018.Day16.Opcodes.eqri(%{:A => 9, :B => 8, :C => 0}, 9)
      %{A: 9, B: 8, C: 1}

      iex> AdventOfCode2018.Day16.Opcodes.eqri(%{:A => 9, :B => 8, :C => 0}, 10)
      %{A: 9, B: 8, C: 0}

      iex> AdventOfCode2018.Day16.Opcodes.eqri(%{:A => 9, :B => 8, :C => 0}, 8)
      %{A: 9, B: 8, C: 0}

  """
  def eqri(register, b_value) when is_integer(b_value) do
    c_value = cond do
      Map.get(register, :A) == b_value -> 1
      true -> 0
    end
    Map.put(register, :C, c_value)
  end

  @doc """
  Sets register C to 1 if register A is equal to value B. Otherwise, register C is set to 0.

  ## Examples

      iex> AdventOfCode2018.Day16.Opcodes.eqrr(%{:A => 9, :B => 9, :C => 0})
      %{A: 9, B: 9, C: 1}

      iex> AdventOfCode2018.Day16.Opcodes.eqrr(%{:A => 9, :B => 8, :C => 0})
      %{A: 9, B: 8, C: 0}

      iex> AdventOfCode2018.Day16.Opcodes.eqrr(%{:A => 9, :B => 10, :C => 0})
      %{A: 9, B: 10, C: 0}

  """
  def eqrr(register) do
    c_value = cond do
      Map.get(register, :A) == Map.get(register, :B) -> 1
      true -> 0
    end
    Map.put(register, :C, c_value)
  end

end
