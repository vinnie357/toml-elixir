Mix.start()
escripts = Mix.path_for(:escripts)

{command, args, options} =
  case System.argv() do
    ["setup"] ->
      separator = if match?({:win32, _}, :os.type()), do: ";", else: ":"
      path = escripts <> separator <> System.get_env("PATH", "")
      {"mix", ["escript.install", "hex", "mix_audit", "2.1.5", "--force"], [env: [{"PATH", path}]]}

    [] ->
      {Path.join(escripts, "mix_audit"), ["--path", ".", "--format=json"], []}
  end

{output, status} = System.cmd(command, args, [stderr_to_stdout: true] ++ options)
IO.write(output)
warning? = Regex.match?(~r/\bwarning:/i, output)
System.halt(if status == 0 and warning?, do: 1, else: status)
