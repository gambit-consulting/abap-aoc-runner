# ABAP AoC Runner

A framework to solve [Advent of Code](https://adventofcode.com/) problems using ABAP.

## Installation

Install this tool in your S/4 system using [abapgit](https://docs.abapgit.org/) in a local package (e.g. `$ADVENTOFCODE`).

## Usage

Each year will have up to 25 ABAP classes. So it might make sense to create a local package for each user and year (e.g. `$AOC2025_MARC`). 

Open the `Participant` entity preview in the service binding `ZUI_AOC_PARTICIPANT_O4`. Create a new entry with the year number you want to solve (e.g. `2025`), the package created for your solutions (e.g. `$AOC2025_MARC`, **not** `$ADVENTOFCODE`) and your auth cookie for the AoC page.

On the detail page of this new row you can now add the days you want to solve. In `Edit` mode create a new `Day` entry and pass the day number (1-25). When pressing `Save` the *ABAP AoC Runner* automatically downloads your puzzle input and creates a class `ZCL_AOC_[SAPUSER]_[YEAR]_[DAY]` (e.g. `ZCL_AOC_MARC_2025_1`). This class is runnable via <kbd>F9</kbd> and executes `solve_part1` and `solve_part2` and prints it to the Eclipse console.

The only thing you need to do is replace the dummy implementation of the solver methods with your real implementation. The puzzle input (a `string_table`) is passed to both methods.

The solver class also contains a local test class that can be filled with the sample input from the AoC page. It can be executed by <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>F10</kbd> or right-clicking your solver class and selecting `Run As > ABAP Unit Test`.

## Caution

I am not an ABAP pro so my framework might need some tweaking. I am very open to suggestions and pull requests.

## To-Dos

- [ ] Other users should not see everones auth cookies (until then please don't abuse others auth cookies 😵)
- [ ] Update counter of "Problems solved" in Participants entity when user marks individual Days as solved
- [ ] Value help for YEARS (custom entity that displays numbers from 2015 to current year)
- [ ] Value help for DAYS (custom or even remote entity that displays numbers of days for each year)
- [ ] Add more screenshots to readme so it has a little more soul.
