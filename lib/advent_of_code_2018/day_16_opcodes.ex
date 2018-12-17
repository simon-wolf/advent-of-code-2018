defmodule AdventOfCode2018.Day16.Opcodes do
  @moduledoc """
  Thanks to bjorng for the doctest data which was taken from:
  https://github.com/bjorng/advent-of-code-2018/blob/master/day16/lib/day16.ex
  """

  use Bitwise

  def set_register([register_0, register_1, register_2, register_3]) do
    %{}
    |> Map.put(:reg0, register_0)
    |> Map.put(:reg1, register_1)
    |> Map.put(:reg2, register_2)
    |> Map.put(:reg3, register_3)
  end

  def get_register(register_map) do
    [ Map.get(register_map, :reg0), Map.get(register_map, :reg1), Map.get(register_map, :reg2), Map.get(register_map, :reg3) ]
  end

   def instruct_register(register_values, instruction, parameters) when is_list(register_values) do
    instruct_register(set_register(register_values), instruction, parameters)
  end

  def instruct_register(register, instruction, parameters) when is_map(register) do
    [opcode_id, input_a, input_b, output_c] = parameters
    |> String.split(" ")
    |> Enum.map(&String.to_integer(&1))

    parameters_map = %{}
    |> Map.put(:ID, opcode_id)
    |> Map.put(:A, input_a)
    |> Map.put(:B, input_b)
    |> Map.put(:C, output_c)

    spec = generate_spec(register, parameters_map)

    result = instruction.(spec)
    Map.put(Map.get(spec, :register), Map.get(spec, :c_atom), result)
    |> get_register
  end


  defp generate_spec(register, parameters) when is_map(register) and is_map(parameters) do
    a_index = Map.get(parameters, :A)
    b_index = Map.get(parameters, :B)
    c_index = Map.get(parameters, :C)

    a_atom = "reg" <> Integer.to_string(a_index) |> String.to_atom
    b_atom = "reg" <> Integer.to_string(b_index) |> String.to_atom
    c_atom = "reg" <> Integer.to_string(c_index) |> String.to_atom

    a_from_register = Map.get(register, a_atom)
    b_from_register = Map.get(register, b_atom)

    a_value = a_index
    b_value = b_index

    %{}
    |> Map.put(:a_reg, a_from_register)
    |> Map.put(:b_reg, b_from_register)
    |> Map.put(:a_val, a_value)
    |> Map.put(:b_val, b_value)
    |> Map.put(:c_atom, c_atom)
    |> Map.put(:register, register)
    |> Map.put(:parameters, parameters)
  end


  @doc """
  Stores into register C the result of adding register A and register B.

  ## Examples

      iex> AdventOfCode2018.Day16.Opcodes.instruct_register([1, 4, 5, 10], &AdventOfCode2018.Day16.Opcodes.addr/1, "0 1 2 0")
      [9, 4, 5, 10]

  """
  def addr(spec) do
    Map.get(spec, :a_reg) + Map.get(spec, :b_reg)
  end

  @doc """
  Stores into register C the result of adding register A and value B.

  ## Examples

      iex> AdventOfCode2018.Day16.Opcodes.instruct_register([1, 4, 5, 10], &AdventOfCode2018.Day16.Opcodes.addi/1, "0 1 42 3")
      [1, 4, 5, 46]

  """
  def addi(spec) do
    Map.get(spec, :a_reg) + Map.get(spec, :b_val)
  end

  @doc """
  Stores into register C the result of multiplying register A and register B.

  ## Examples

      iex> AdventOfCode2018.Day16.Opcodes.instruct_register([1, 4, 5, 10], &AdventOfCode2018.Day16.Opcodes.mulr/1, "0 1 2 0")
      [20, 4, 5, 10]

  """
  def mulr(spec) do
    Map.get(spec, :a_reg) * Map.get(spec, :b_reg)
  end

  @doc """
  Stores into register C the result of multiplying register A and value B.

  ## Examples

      iex> AdventOfCode2018.Day16.Opcodes.instruct_register([1, 4, 5, 10], &AdventOfCode2018.Day16.Opcodes.muli/1, "0 1 42 3")
      [1, 4, 5, 168]

  """
  def muli(spec) do
    Map.get(spec, :a_reg) * Map.get(spec, :b_val)
  end

  @doc """
  Stores into register C the result of the bitwise AND of register A and register B.

  ## Examples

      iex> AdventOfCode2018.Day16.Opcodes.instruct_register([1, 5, 13, 10], &AdventOfCode2018.Day16.Opcodes.banr/1, "0 1 2 0")
      [5, 5, 13, 10]

  """
  def banr(spec) do
    Map.get(spec, :a_reg) &&& Map.get(spec, :b_reg)
  end

  @doc """
  Stores into register C the result of the bitwise AND of register A and value B.

  ## Examples

      iex> AdventOfCode2018.Day16.Opcodes.instruct_register([1, 4, 5, 10], &AdventOfCode2018.Day16.Opcodes.bani/1, "0 3 8 0")
      [8, 4, 5, 10]

  """
  def bani(spec) do
    Map.get(spec, :a_reg) &&& Map.get(spec, :b_val)
  end

  @doc """
  Stores into register C the result of the bitwise OR of register A and register B.

  ## Examples

      iex> AdventOfCode2018.Day16.Opcodes.instruct_register([1, 5, 9, 10], &AdventOfCode2018.Day16.Opcodes.borr/1, "0 1 2 0")
      [13, 5, 9, 10]

  """
  def borr(spec) do
    # bor(Map.get(spec, :a_reg), Map.get(spec, :b_reg))
    Map.get(spec, :a_reg) ||| Map.get(spec, :b_reg)
  end

  @doc """
  Stores into register C the result of the bitwise OR of register A and value B.

  ## Examples

      iex> AdventOfCode2018.Day16.Opcodes.instruct_register([1, 4, 5, 10], &AdventOfCode2018.Day16.Opcodes.bori/1, "0 3 32 0")
      [42, 4, 5, 10]

  """
  def bori(spec) do
    # bor(Map.get(spec, :a_reg), Map.get(spec, :b_val))
    Map.get(spec, :a_reg) ||| Map.get(spec, :b_val)
  end

  @doc """
  Copies the contents of register A into register C. (Input B is ignored.)

  ## Examples

      iex> AdventOfCode2018.Day16.Opcodes.instruct_register([1, 4, 5, 10], &AdventOfCode2018.Day16.Opcodes.setr/1, "0 3 999 1")
      [1, 10, 5, 10]

  """
  def setr(spec) do
    Map.get(spec, :a_reg)
  end

  @doc """
  Stores value A into register C. (Input B is ignored.)

  ## Examples

      iex> AdventOfCode2018.Day16.Opcodes.instruct_register([1, 4, 5, 10], &AdventOfCode2018.Day16.Opcodes.seti/1, "0 777 999 0")
      [777, 4, 5, 10]

  """
  def seti(spec) do
    Map.get(spec, :a_val)
  end

  @doc """
  Sets register C to 1 if value A is greater than register B. Otherwise, register C is set to 0.

  ## Examples

      iex> AdventOfCode2018.Day16.Opcodes.instruct_register([1, 4, 5, 10], &AdventOfCode2018.Day16.Opcodes.gtir/1, "0 7 2 0")
      [1, 4, 5, 10]

      iex> AdventOfCode2018.Day16.Opcodes.instruct_register([1, 4, 5, 10], &AdventOfCode2018.Day16.Opcodes.gtir/1, "0 0 2 0")
      [0, 4, 5, 10]

  """
  def gtir(spec) do
    cond do
      Map.get(spec, :a_val) > Map.get(spec, :b_reg) -> 1
      true -> 0
    end
  end

  @doc """
  Sets register C to 1 if register A is greater than value B. Otherwise, register C is set to 0.

  ## Examples

      iex> AdventOfCode2018.Day16.Opcodes.instruct_register([1, 4, 5, 10], &AdventOfCode2018.Day16.Opcodes.gtri/1, "0 3 9 0")
      [1, 4, 5, 10]
      
      iex> AdventOfCode2018.Day16.Opcodes.instruct_register([1, 4, 5, 10], &AdventOfCode2018.Day16.Opcodes.gtri/1, "0 2 9 0")
      [0, 4, 5, 10]

  """
  def gtri(spec) do
    cond do
      Map.get(spec, :a_reg) > Map.get(spec, :b_val) -> 1
      true -> 0
    end
  end

  @doc """
  Sets register C to 1 if register A is greater than register B. Otherwise, register C is set to 0.

  ## Examples

      iex> AdventOfCode2018.Day16.Opcodes.instruct_register([1, 4, 5, 10], &AdventOfCode2018.Day16.Opcodes.gtrr/1, "0 3 2 0")
      [1, 4, 5, 10]
      
      iex> AdventOfCode2018.Day16.Opcodes.instruct_register([1, 4, 5, 10], &AdventOfCode2018.Day16.Opcodes.gtrr/1, "0 1 2 0")
      [0, 4, 5, 10]

  """
  def gtrr(spec) do
    cond do
      Map.get(spec, :a_reg) > Map.get(spec, :b_reg) -> 1
      true -> 0
    end
  end

  @doc """
  Sets register C to 1 if value A is equal to register B. Otherwise, register C is set to 0.

  ## Examples

      iex> AdventOfCode2018.Day16.Opcodes.instruct_register([1, 4, 5, 10], &AdventOfCode2018.Day16.Opcodes.eqir/1, "0 4 1 0")
      [1, 4, 5, 10]
      
      iex> AdventOfCode2018.Day16.Opcodes.instruct_register([1, 4, 5, 10], &AdventOfCode2018.Day16.Opcodes.eqir/1, "0 42 1 0")
      [0, 4, 5, 10]

  """
  def eqir(spec) do
    cond do
      Map.get(spec, :a_val) == Map.get(spec, :b_reg) -> 1
      true -> 0
    end
  end

  @doc """
  Sets register C to 1 if register A is equal to value B. Otherwise, register C is set to 0.

  ## Examples

      iex> AdventOfCode2018.Day16.Opcodes.instruct_register([1, 4, 5, 10], &AdventOfCode2018.Day16.Opcodes.eqri/1, "0 3 10 0")
      [1, 4, 5, 10]
      
      iex> AdventOfCode2018.Day16.Opcodes.instruct_register([1, 4, 5, 10], &AdventOfCode2018.Day16.Opcodes.eqri/1, "0 3 19 0")
      [0, 4, 5, 10]

  """
  def eqri(spec) do
    cond do
      Map.get(spec, :a_reg) == Map.get(spec, :b_val) -> 1
      true -> 0
    end
  end

  @doc """
  Sets register C to 1 if register A is equal to register B. Otherwise, register C is set to 0.

  ## Examples

      iex> AdventOfCode2018.Day16.Opcodes.instruct_register([1, 4, 5, 10], &AdventOfCode2018.Day16.Opcodes.eqrr/1, "0 3 2 0")
      [0, 4, 5, 10]
      
      iex> AdventOfCode2018.Day16.Opcodes.instruct_register([1, 4, 10, 10], &AdventOfCode2018.Day16.Opcodes.eqrr/1, "0 3 2 0")
      [1, 4, 10, 10]

  """
  def eqrr(spec) do
    cond do
      Map.get(spec, :a_reg) == Map.get(spec, :b_reg) -> 1
      true -> 0
    end
  end

end
