# advent-of-code-2022
Tooling &amp; Solutions for Advent of Code 2022 problems

## CLI
CLI currently supports scaffolding of a new solution folder structure with base solution file and running a solution against a given input file located within the solution folder.

You can create a new solution folder by running the following command in the root directory

```crystal cli/cli.cr new -f <folder_name>```

you can run a solution against the sample input by running the following command in the root directory

```crystal cli/cli.cr run -f <folder_name>```

you can run a solution against an arbitrary input file in ```solutions/<folder_name>/in/<input_name>.in``` with the following command in the root directory

```crystal cli/cli.cr run -f <folder_name> -i <input_name>```
