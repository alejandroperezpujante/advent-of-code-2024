defmodule Aoc2024.CLI do
  @type day :: 1..25
  @type input_file :: String.t()
  @type parse_result ::
          :help
          | {:ok, day, input_file}
          | {:error, :invalid_day}
          | {:error, :missing_input_file}
          | {:error, :input_file_not_found, input_file}

  @spec run(list(String.t())) :: no_return()
  def run(args) do
    args
    |> parse_args()
    |> process()
  end

  @spec parse_args(list(String.t())) :: parse_result
  defp parse_args(args) do
    {parsed, argv, errors} =
      OptionParser.parse(args,
        strict: [help: :boolean, day: :integer],
        aliases: [h: :help, d: :day]
      )

    case {parsed, argv, errors} do
      {[help: true], _, _} -> :help
      {[day: _day], [], _} -> {:error, :missing_input_file}
      {[day: day], [input_file], _} when day in 1..25 -> validate_input_file(day, input_file)
      {[day: _], _, _} -> {:error, :invalid_day}
      {_, _, _} -> :help
    end
  end

  @spec validate_input_file(day, input_file) ::
          {:ok, day, input_file} | {:error, :input_file_not_found, input_file}
  defp validate_input_file(day, input_file) do
    case File.exists?(input_file) do
      true -> {:ok, day, input_file}
      false -> {:error, :input_file_not_found, input_file}
    end
  end

  @spec shutdown(non_neg_integer()) :: no_return()
  defp shutdown(code) do
    System.stop(code)
    Process.sleep(:infinity)
  end

  @spec process(:help) :: :ok
  defp process(:help) do
    IO.puts("""
    Usage: aoc2024 --day <1-25> <input_file>

    Options:
      -d, --day      Specify day (1-25)
      -h, --help     Show this help message

    Example:
      aoc2024 --day 1 input.txt
    """)

    :ok
  end

  @spec process({:error, :invalid_day}) :: no_return()
  defp process({:error, :invalid_day}) do
    IO.puts("Error: Day must be between 1 and 25")
    shutdown(1)
  end

  @spec process({:error, :missing_input_file}) :: no_return()
  defp process({:error, :missing_input_file}) do
    IO.puts("Error: Input file must be provided")
    shutdown(1)
  end

  @spec process({:error, :input_file_not_found, input_file}) :: no_return()
  defp process({:error, :input_file_not_found, file}) do
    IO.puts("Error: Input file not found: #{file}")
    shutdown(1)
  end

  @spec process({:ok, day, input_file}) :: :ok | no_return()
  defp process({:ok, day, input_file}) do
    IO.puts("Processing day #{day} with input file: #{input_file}")

    try do
      module = Module.concat(Aoc2024, "Day#{String.pad_leading("#{day}", 2, "0")}")
      module.solve(input_file)
    rescue
      UndefinedFunctionError ->
        IO.puts("Error: Solution for day #{day} not implemented yet")
        shutdown(1)
    end
  end
end
