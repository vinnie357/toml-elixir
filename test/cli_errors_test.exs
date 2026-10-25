defmodule Toml.CliErrorsTest do
  use ExUnit.Case, async: true

  test "unsupported conversion format reports the diagnostic without a function-clause crash" do
    executable = System.find_executable("elixir")
    assert is_binary(executable)

    {output, status} =
      System.cmd(
        executable,
        [
          "--erl",
          "+S 2:2",
          "-pa",
          Mix.Project.compile_path(),
          "-e",
          ~s(Toml.CLI.main(["convert", "--format", "yaml", "--stdin"]))
        ],
        stderr_to_stdout: true
      )

    assert status == 1
    assert output =~ "Invalid conversion format 'yaml'. Supported formats are: 'json'."
    refute output =~ "FunctionClauseError"
  end
end
