defmodule StepInfo do
  defstruct duration: 0, start_at: -1, end_at: -1, dependent_on: []
end

defmodule Worker do
  defstruct processing: "", available_at: 0
end

defmodule AdventOfCode2018.Day07 do
  @moduledoc false

  @doc """
  --- Day 7: The Sum of Its Parts ---

  You find yourself standing on a snow-covered coastline; apparently, you 
  landed a little off course. The region is too hilly to see the North Pole 
  from here, but you do spot some Elves that seem to be trying to unpack 
  something that washed ashore. It's quite cold out, so you decide to risk 
  creating a paradox by asking them for directions.

  "Oh, are you the search party?" Somehow, you can understand whatever Elves 
  from the year 1018 speak; you assume it's Ancient Nordic Elvish. Could the 
  device on your wrist also be a translator? "Those clothes don't look very 
  warm; take this." They hand you a heavy coat.

  "We do need to find our way back to the North Pole, but we have higher 
  priorities at the moment. You see, believe it or not, this box contains 
  something that will solve all of Santa's transportation problems - at least, 
  that's what it looks like from the pictures in the instructions." It doesn't 
  seem like they can read whatever language it's in, but you can: "Sleigh kit. 
  Some assembly required."

  "'Sleigh'? What a wonderful name! You must help us assemble this 'sleigh' at 
  once!" They start excitedly pulling more parts out of the box.

  The instructions specify a series of steps and requirements about which steps 
  must be finished before others can begin (your puzzle input). Each step is 
  designated by a single letter. For example, suppose you have the following 
  instructions:

  Step C must be finished before step A can begin.
  Step C must be finished before step F can begin.
  Step A must be finished before step B can begin.
  Step A must be finished before step D can begin.
  Step B must be finished before step E can begin.
  Step D must be finished before step E can begin.
  Step F must be finished before step E can begin.

  Visually, these requirements look like this:

    -->A--->B--
  /    \      \
  C      -->D----->E
  \           /
    ---->F-----

  Your first goal is to determine the order in which the steps should be 
  completed. If more than one step is ready, choose the step which is first 
  alphabetically. In this example, the steps would be completed as follows:

  - Only C is available, and so it is done first.
  - Next, both A and F are available. A is first alphabetically, so it is done 
    next.
  - Then, even though F was available earlier, steps B and D are now also 
    available, and B is the first alphabetically of the three.
  - After that, only D and F are available. E is not available because only 
    some of its prerequisites are complete. Therefore, D is completed next.
  - F is the only choice, so it is done next.
  - Finally, E is completed.

  So, in this example, the correct order is CABDFE.

  In what order should the steps in your instructions be completed?
  """
  def part1(file_path) do
    steps = file_path
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.map(&parse_instruction/1)
    |> Enum.to_list()
    |> generate_step_info(false, 0)

    workers = generate_workers(1)

    {steps, current_time} = process_steps(steps, workers, 0, [])
  end

  @doc """
  As you're about to begin construction, four of the Elves offer to help. "The 
  sun will set soon; it'll go faster if we work together." Now, you need to 
  account for multiple people working on steps simultaneously. If multiple 
  steps are available, workers should still begin them in alphabetical order.

  Each step takes 60 seconds plus an amount corresponding to its letter: A=1, 
  B=2, C=3, and so on. So, step A takes 60+1=61 seconds, while step Z takes 
  60+26=86 seconds. No time is required between steps.

  To simplify things for the example, however, suppose you only have help from 
  one Elf (a total of two workers) and that each step takes 60 fewer seconds 
  (so that step A takes 1 second and step Z takes 26 seconds). Then, using the 
  same instructions as above, this is how each second would be spent:

  Second   Worker 1   Worker 2   Done
    0        C          .        
    1        C          .        
    2        C          .        
    3        A          F       C
    4        B          F       CA
    5        B          F       CA
    6        D          F       CAB
    7        D          F       CAB
    8        D          F       CAB
    9        D          .       CABF
   10        E          .       CABFD
   11        E          .       CABFD
   12        E          .       CABFD
   13        E          .       CABFD
   14        E          .       CABFD
   15        .          .       CABFDE

  Each row represents one second of time. The Second column identifies how many 
  seconds have passed as of the beginning of that second. Each worker column 
  shows the step that worker is currently doing (or . if they are idle). The 
  Done column shows completed steps.

  Note that the order of the steps has changed; this is because steps now take 
  time to finish and multiple workers can begin multiple steps simultaneously.

  In this example, it would take 15 seconds for two workers to complete these 
  steps.

  With 5 workers and the 60+ second step durations described above, how long 
  will it take to complete all of the steps?
  """
  def part2(file_path) do
    steps = file_path
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.map(&parse_instruction/1)
    |> Enum.to_list()
    |> generate_step_info(true, 60)

    workers = generate_workers(5)

    {steps, current_time} = process_steps(steps, workers, 0, [])
  end


  # Split the instruction string into a tuple of dependencies
  defp parse_instruction(instruction) do
    { String.slice(instruction, 5..5), String.slice(instruction, 36..36) }
  end

  # Generate a map of StepInfo structs to define steps, dependencies, duraions, etc.
  defp generate_step_info(dependencies_tuples, add_duration, extra_time) do
    dependencies_tuples
    |> Enum.reduce(%{}, fn {do_this, before_this}, acc -> 
      acc = Map.put_new(acc, do_this, %StepInfo{ duration: step_value(do_this, add_duration, extra_time) })
      acc = Map.put_new(acc, before_this, %StepInfo{ duration: step_value(before_this, add_duration, extra_time) })

      step_info = Map.get(acc, before_this)
      dependencies = step_info.dependent_on
      new_dependencies = [do_this] ++ dependencies
      new_step_info = %{ step_info | dependent_on: new_dependencies }

      Map.put(acc, before_this, new_step_info)
    end)
  end

  defp generate_workers(number_of_workers) do
    workers = Enum.reduce(1..number_of_workers, %{}, fn worker_id, workers ->
      Map.put(workers, worker_id, %Worker{})
    end)
  end

  # The actual data processing
  defp process_steps(steps, workers, current_time, completed_steps) when steps == %{} do
    {updated_workers, newly_completed_steps} = update_workers(workers, current_time)
    all_completed_steps = newly_completed_steps ++ completed_steps

    active_count = Enum.reduce(Map.keys(workers), 0, fn worker_id, active_worker_count ->
      worker = Map.get(workers, worker_id)
      if worker.available_at > current_time do
        active_worker_count + 1
      else
        active_worker_count
      end
    end)

    if active_count == 0 do
      steps = all_completed_steps
      |> Enum.reverse()
      |> List.to_string()
      {steps, current_time}
    else
      process_steps(steps, updated_workers, current_time + 1, all_completed_steps)
    end
  end

  defp process_steps(steps, workers, current_time, completed_steps) do
    # Remove and log any completed steps
    {updated_workers, newly_completed_steps} = update_workers(workers, current_time)

    all_completed_steps = newly_completed_steps ++ completed_steps
    updated_steps = update_steps(steps, newly_completed_steps)

    # Assign any available tasks to any available workers
    {updated_steps, updated_workers, _current_time} = assign_tasks(updated_steps, updated_workers, current_time)

    process_steps(updated_steps, updated_workers, current_time + 1, all_completed_steps)
  end

  defp update_workers(workers, current_time) do
    {updated_workers, steps_finished_this_tick} = Enum.reduce(Map.keys(workers), {%{}, []}, fn worker_id, {new_workers, steps_finished} ->
      worker = Map.get(workers, worker_id)
      if worker.available_at == current_time && worker.processing != "" do
        { Map.put(new_workers, worker_id, %Worker{available_at: -1, processing: ""}), [worker.processing] ++ steps_finished}
      else
        { Map.put(new_workers, worker_id, worker), steps_finished}
      end
    end)

    {updated_workers, steps_finished_this_tick}
  end

  defp update_steps(steps, newly_completed_steps) do
    completed_steps = MapSet.new(newly_completed_steps)

    Map.keys(steps)
    |> Enum.reduce(%{}, fn key, acc -> 
      step = Map.get(steps, key)

      step_dependencies = MapSet.new(step.dependent_on)
      updated_dependencies = MapSet.difference(step_dependencies, completed_steps)

      new_step_info = %{ step | dependent_on: MapSet.to_list(updated_dependencies) }
      Map.put(acc, key, new_step_info)
    end)
  end

  defp assign_tasks(steps, workers, current_time) do
    next_task = next_available_step(steps)

    available_worker = Map.keys(workers)
    |> Enum.reduce_while(-1, fn worker_id, acc ->
      worker = Map.get(workers, worker_id)
      if Map.get(worker, :processing) == "", do: {:halt, worker_id}, else: {:cont, acc}
    end)

    if next_task == nil || available_worker == -1 do
      {steps, workers, current_time}
    else
      task = Map.get(steps, next_task)

      worker = Map.get(workers, available_worker)
      |> Map.put(:processing, next_task)
      |> Map.put(:available_at, current_time + task.duration)

      new_workers = Map.put(workers, available_worker, worker)

      new_steps = Map.delete(steps, next_task)
      
      assign_tasks(new_steps, new_workers, current_time)
    end
  end

  defp next_available_step(steps) do
    Map.keys(steps)
    |> Enum.reduce([], fn key, acc -> 
      step = Map.get(steps, key)
      if length(step.dependent_on) == 0 do
        [key] ++ acc
      else
        acc
      end
    end)
    |> Enum.sort()
    |> List.first()
  end

  defp next_available_worker(workers) do
    available_worker_ids = Enum.reduce(workers, [], fn worker, acc ->
      current_step = worker.processing
      if (current_step = "") do
        [worker.id] ++ acc
      else
        acc
      end
    end)
    |> IO.inspect label: "Available Worker IDs"
  end

  defp step_value(letter, false, _) do
    1
  end

  defp step_value(letter, true, extra_time) do
    char_list = letter
    |> String.upcase()
    |> String.to_charlist()

    [head | _tail] = char_list
    head - 64 + extra_time
  end

end
