# What makes up a crossword puzzle?
Crossword

    Grid                <-  Implies the number of Clues and their Direction, Number
        Row                 and (except (3,4,5) style clues) Length
            Cell

    Clues
        Clue
            Direction
            Number
            Length
            Content
            Value

    Solutions
        Solution
            Direction
            Number
            Value

# Different types of crosswords
    Creation
        Create a grid, or use a pre-built grid. You then need to complete
        the Solutions first, and finally add the Clues.

    Attempt
        Grid and Clues are provided. You attempt to complete the Solutions,
        checking them one-by-one.

# What do users want to save?
 *  Creators want to save complete Grid, Clues and Solutions.
 *  Each Creation can have unlimited Attempts. At first, they should probably
    just be saved in local storage.
