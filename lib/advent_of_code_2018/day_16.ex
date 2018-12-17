defmodule AdventOfCode2018.Day16 do
  @moduledoc false

  @doc """
  --- Day 16: Chronal Classification ---

  As you see the Elves defend their hot chocolate successfully, you go back to 
  falling through time. This is going to become a problem.

  If you're ever going to return to your own time, you need to understand how 
  this device on your wrist works. You have a little while before you reach 
  your next destination, and with a bit of trial and error, you manage to pull 
  up a programming manual on the device's tiny screen.

  According to the manual, the device has four registers (numbered 0 through 
  3) that can be manipulated by instructions containing one of 16 opcodes. The 
  registers start with the value 0.

  Every instruction consists of four values: an opcode, two inputs (named A and 
  B), and an output (named C), in that order. The opcode specifies the behavior 
  of the instruction and how the inputs are interpreted. The output, C, is 
  always treated as a register.

  In the opcode descriptions below, if something says "value A", it means to 
  take the number given as A literally. (This is also called an "immediate" 
  value.) If something says "register A", it means to use the number given as 
  A to read from (or write to) the register with that number. So, if the 
  opcode addi adds register A and value B, storing the result in register C, 
  and the instruction addi 0 7 3 is encountered, it would add 7 to the value 
  contained by register 0 and store the sum in register 3, never modifying 
  registers 0, 1, or 2 in the process.

  Many opcodes are similar except for how they interpret their arguments. The 
  opcodes fall into seven general categories:

  Addition:

  - addr (add register) stores into register C the result of adding register A 
    and register B.
  - addi (add immediate) stores into register C the result of adding register 
    A and value B.

  Multiplication:

  - mulr (multiply register) stores into register C the result of multiplying 
    register A and register B.
  - muli (multiply immediate) stores into register C the result of multiplying 
    register A and value B.

  Bitwise AND:

  - banr (bitwise AND register) stores into register C the result of the 
    bitwise AND of register A and register B.
  - bani (bitwise AND immediate) stores into register C the result of the 
    bitwise AND of register A and value B.

  Bitwise OR:

  - borr (bitwise OR register) stores into register C the result of the 
    bitwise OR of register A and register B.
  - bori (bitwise OR immediate) stores into register C the result of the 
    bitwise OR of register A and value B.

  Assignment:

  - setr (set register) copies the contents of register A into register C. 
    (Input B is ignored.)
  - seti (set immediate) stores value A into register C. (Input B is ignored.)

  Greater-than testing:

  - gtir (greater-than immediate/register) sets register C to 1 if value A is 
    greater than register B. Otherwise, register C is set to 0.
  - gtri (greater-than register/immediate) sets register C to 1 if register A 
    is greater than value B. Otherwise, register C is set to 0.
  - gtrr (greater-than register/register) sets register C to 1 if register A is 
    greater than register B. Otherwise, register C is set to 0.

  Equality testing:

  - eqir (equal immediate/register) sets register C to 1 if value A is equal to 
    register B. Otherwise, register C is set to 0.
  - eqri (equal register/immediate) sets register C to 1 if register A is equal 
    to value B. Otherwise, register C is set to 0.
  - eqrr (equal register/register) sets register C to 1 if register A is equal 
    to register B. Otherwise, register C is set to 0.

  Unfortunately, while the manual gives the name of each opcode, it doesn't 
  seem to indicate the number. However, you can monitor the CPU to see the 
  contents of the registers before and after instructions are executed to try 
  to work them out. Each opcode has a number from 0 through 15, but the manual 
  doesn't say which is which. For example, suppose you capture the following 
  sample:

  Before: [3, 2, 1, 1]
  9 2 1 2
  After:  [3, 2, 2, 1]

  This sample shows the effect of the instruction 9 2 1 2 on the registers. 
  Before the instruction is executed, register 0 has value 3, register 1 has 
  value 2, and registers 2 and 3 have value 1. After the instruction is 
  executed, register 2's value becomes 2.

  The instruction itself, 9 2 1 2, means that opcode 9 was executed with A=2, 
  B=1, and C=2. Opcode 9 could be any of the 16 opcodes listed above, but only 
  three of them behave in a way that would cause the result shown in the 
  sample:

  - Opcode 9 could be mulr: register 2 (which has a value of 1) times register 
    1 (which has a value of 2) produces 2, which matches the value stored in 
    the output register, register 2.
  - Opcode 9 could be addi: register 2 (which has a value of 1) plus value 1 
    produces 2, which matches the value stored in the output register, 
    register 2.
  - Opcode 9 could be seti: value 2 matches the value stored in the output 
    register, register 2; the number given for B is irrelevant.

  None of the other opcodes produce the result captured in the sample. Because 
  of this, the sample above behaves like three opcodes.

  You collect many of these samples (the first section of your puzzle input). 
  The manual also includes a small test program (the second section of your 
  puzzle input) - you can ignore it for now.

  Ignoring the opcode numbers, how many samples in your puzzle input behave 
  like three or more opcodes?
  """
  def part1(file_path) do
    opcodes = build_opcodes_map()

    samples_analysis = get_samples(file_path)
    |> Enum.reduce([], fn sample, acc ->

      opcodes = Map.keys(opcodes)
      |> Enum.reduce([], fn function_name, valid_opcodes ->
        output = AdventOfCode2018.Day16.Opcodes.instruct_register(Map.get(sample, :input), Map.get(opcodes, function_name), Map.get(sample, :instruction))
        if output == Map.get(sample, :expected_output) do
          [function_name] ++ valid_opcodes
        else
          valid_opcodes
        end
      end)

      [opcodes] ++ acc
    end)

    filtered_results = Enum.filter(samples_analysis, fn sample ->
      length(sample) > 2
    end)
    |> Enum.count()
  end

  @doc """
  Using the samples you collected, work out the number of each opcode and 
  execute the test program (the second section of your puzzle input).

  What value is contained in register 0 after executing the test program?  
  """
  def part2(args) do
    
  end

  def build_opcodes_map() do
    %{}
    |> Map.put("addr", &AdventOfCode2018.Day16.Opcodes.addr/1)
    |> Map.put("addi", &AdventOfCode2018.Day16.Opcodes.addi/1)
    |> Map.put("mulr", &AdventOfCode2018.Day16.Opcodes.mulr/1)
    |> Map.put("muli", &AdventOfCode2018.Day16.Opcodes.muli/1)
    |> Map.put("banr", &AdventOfCode2018.Day16.Opcodes.banr/1)
    |> Map.put("bani", &AdventOfCode2018.Day16.Opcodes.bani/1)
    |> Map.put("borr", &AdventOfCode2018.Day16.Opcodes.borr/1)
    |> Map.put("bori", &AdventOfCode2018.Day16.Opcodes.bori/1)
    |> Map.put("setr", &AdventOfCode2018.Day16.Opcodes.setr/1)
    |> Map.put("seti", &AdventOfCode2018.Day16.Opcodes.seti/1)
    |> Map.put("gtir", &AdventOfCode2018.Day16.Opcodes.gtir/1)
    |> Map.put("gtri", &AdventOfCode2018.Day16.Opcodes.gtri/1)
    |> Map.put("gtrr", &AdventOfCode2018.Day16.Opcodes.gtrr/1)
    |> Map.put("eqir", &AdventOfCode2018.Day16.Opcodes.eqir/1)
    |> Map.put("eqri", &AdventOfCode2018.Day16.Opcodes.eqri/1)
    |> Map.put("eqrr", &AdventOfCode2018.Day16.Opcodes.eqrr/1)
  end

  def get_samples(file_path) do
    file_path
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Enum.to_list()
    |> parse_file_lines([])
    # |> IO.inspect

    # [
    #   %{input: [3, 2, 1, 1], instruction: "9 2 1 2", expected_output: [3, 2, 2, 1]},
    #   %{input: [2, 0, 2, 2], instruction: "3 0 2 1", expected_output: [2, 1, 2, 2]} 
    # ]
    # |> IO.inspect
  end

  defp parse_file_lines([input, instruction, expected_output, "" | tail], parsed_lines) do
    cleaned_input = String.slice(input, 7..-1)
    |> String.trim()
    |> string_to_list()

    cleaned_expected_output = String.slice(expected_output, 6..-1)
    |> String.trim()
    |> string_to_list()

    new_parsed_lines = [%{input: cleaned_input, instruction: instruction, expected_output: cleaned_expected_output}] ++ parsed_lines
    parse_file_lines(tail, new_parsed_lines)
  end

  defp parse_file_lines(["", "" | tail], parsed_lines) do
    parsed_lines
  end

  defp string_to_list(list_string) do
    numbers_string = String.slice(list_string, 1..-2)
    strings_list = String.split(numbers_string, ", ")
    Enum.map(strings_list, &String.to_integer/1)
  end

end
