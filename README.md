# Mysweeper

This is a small web service to design and record board layouts for the game Minesweeper, as an interview take-home test.

## Versions

- rails 7.0.4.3
- ruby 3.2.2

## Installation/Running

### Locally

Clone the repo, then

```
cd mysweeper
rake db:create
bin/dev
```

### Heroku

This is ready to deply to Heroku, as follows:
```
*to be tested*
```

## Tests
```
rspec spec
```

## Design

The requirements are documented in [[Ruby Task.docx]]. In summary:

- The root url provides a 'new board' form where we enter a board name, email, board dimensions and #bombs.
- Creating the record takes us to a view of the record, showing the form info, and a representation of the generated board.
- The 'home' page should also include the 10 most recent board generations, and a button link to a full index page showing all boards generated. Each index item should include at least name, email, creation date (formated).
- The test states that the board generation algorithm is the heart of the challenge, and is to be 'performant', and able to generate 'any' size board.

In this case a few points could not be clarified:

- Whether the board should be deterministic (ie playable without having to guess)
- Should the project be structured so that it can be used to to save actual in-progress games etc in future, or just to generate and record board/mine layouts?


## ADRs

#### Task goals
- Context
  - The task requirement focuses on the board generation algorithm
- Decision
  - Rails views, styling etc will be basic and minimal. We'll use a vanilla stack.
- Consequence
  - No beauty awards.

#### Presentation
- Context
  - It shouldn't be *too* ugly.
- Decision
  - We need some css. We'll Use tailwind css, because it's the hot thing, and I don't know it.
- Consequence
  - I will learn something from this task, whatever. It might still look ugly.

#### Board parameters
- Context
  - Nothing is specified about the board parameters. Maximum size? The spec says board generation should return a 2d map of the board, so I assume 'any size' does not mean we need to accommodate arbitrary-sized boards.
- Decision
  Maximum board size will be 1000x1000. Simple validations that sides are <1000, #mines are less than #tiles.
- Consequence
  - Resources will be bounded.


#### Board content
- Context
  - The spec says only that we should produce a 2d array showing empty tiles and bombs. Should we also calculate 'nearest neighbour counts'? Should boards be deterministic (solvable without guessing)? Should we tune mine density? For example there are lots of resources at [minesweepergame](https://minesweepergame.com/math-papers.php) discussing things like a phase transition (~= sudden increase in difficulty) at a mine density of around 0.25.
- Decision
  - Mines will be (pseudo-)randomly generated, no solver to check if it's solvable, no clustering heuristics or adjustments, etc, no calculation of #neighbours.
- Consequence
  - Only really need boolean values for each tile.


#### Board storage
- Context
  - The spec does not say in what format the board should be saved, or if we should consider a future where we need to store game state (flags, uncovered tiles).
  - With a randomly generated board, so long as it's deterministic, do we even need to store board? We could just store the random seed to generate the board. The board could even be generated/rendered on the client.
  - We could store just bomb positions. This would make it easy to render the board by adding bombs (and updating nearest neighbour counts at the same time) to an empty board array. If required in future we could store game state in a similar manner, with lists of uncovered tiles, marked tiles etc. Or even better, as transactions.
  - We could store the rendered board. Simplest would just be a postgress array of booleans. We could get fancy with a bitmap, sliced into 32/64 bit ints (maybe postgres is already adept at storing boolean arrays?). If the boards are sparse and clustered we could go with a quadtree or another sparse-matrix method (list-of lists, etc)
  - Should we store the grid as an object together with the name/email etc, or separately?
- Decision
  - Experiment a little, but since the requirements are generic, possibly just a simple postgres 2d array of boolean, stored as a field in the 'board' model.
- Consequence
  - The board will not be updatable efficiently.


#### Mine placement
- Context
  - We need to generate n randomly-placed bombs on the grid in a 'performant' manner. We need to avoid cvollisions with previously-placed bombs. If the board is 'full' this lookup needs to be efficient. A hash table of existing bombs is the obvious solution. Another option is to avoid the problem altogether, by using random nunmbers that don't collide, ie an LSFR.
- Decision
  - Use a hash table, maybe do the LFSR too for fun
- Consequence
  - Can handle very dense boards




