# Advent of Code 2024, in Elixir!

This repo is Alejandro Pérez Pujante's attempt at solving the [Advent of Code](https://adventofcode.com) challenges in Elixir.

## Prerequisites

- Elixir 1.17.3 or later
- Erlang/OTP 27 or later

## Installation

Clone this repo and run `mix deps.get` to install dependencies.

## Usage

Compile the elixir code into an executable with:

```shell
mix escript.build
```

Then, run the app selecting the day and the input file:

```shell
./aoc_2024 --day=1 day_one_input.txt
```

## Testing

To run the tests, use the following command:

```shell
mix test
```

## License

This project is licensed under the MIT License.
