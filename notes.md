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

# API data types
 *  Puzzle {
        Grid: [     // a list of uniform-length strings
            "@ @",  // representing the crossword's rows.
            " @ "   // space is a white square and @ is black.
        ]           
        Clues: {
            Across: { [
                n: {
                    length: int
                    text: string
                }
            ] }
            Down: { [
                // as above
            ] }
        }
        Meta: {
            Id:        string // hash of the key in the back end,
                              // or a magic ID for unsaved local puzzles
            (Title:    string) 
            (Author:   string)
            (Date:     string)
        }
    }
 *  Attempt {
        Grid: [     // spaces from a Puzzle.Grid can be 
            "@A@",  // replaced by guessed letters.
            "B@C"
        ]
        Meta: {
            Id:     string
        }
    }

# API methods
 *  ListPuzzles :: -> [ Puzzle ]
 *  CreatePuzzle :: Grid, Clues, Meta -> Id
 *  UpdatePuzzle :: Id, (Grid), (Clues), (Meta) ->
