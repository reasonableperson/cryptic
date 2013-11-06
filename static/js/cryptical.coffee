countAnswerLength = (cells, i, j, direction) ->
    length = 0
    if direction is 'across'
        while j < cells[i].length and cells[i][j].class isnt 'black'
            j++; length++
    if direction is 'down'
        while i < cells.length and cells[i][j].class isnt 'black'
            i++; length++
    return length

# Step over the cells of a crossword grid and number them,
# attaching a dictionary of empty clues to the crossword.
analyseGrid = (crossword) ->
    counter = 0
    clues = crossword.clues or {across: {}, down: {}}
    cells = crossword.cells
    for row, i in cells
        for cell, j in row when cell.class isnt 'black'
            up = if i > 0 then (cells[i-1][j].class isnt 'black') else false
            down = if i+1 < cells.length then (cells[i+1][j].class isnt 'black') else false
            left = if j > 0 then (row[j-1].class isnt 'black') else false
            right = if j+1 < row.length then (row[j+1].class isnt 'black') else false
            if right and not left   # across clue
                cell.num = ++counter
                if not clues.across[cell.num]?
                    clues.across[cell.num] =
                        length: countAnswerLength cells, i, j, 'across'
            if down and not up      # down clue
                if not right or left
                    cell.num = ++counter
                if not clues.down[cell.num]?
                    clues.down[cell.num] =
                        length: countAnswerLength cells, i, j, 'down'

class Crossword
    constructor: -> 
        # look in local storage if no string provided
        if not crosswordString? then crosswordString = localStorage['crossword']
        @load crosswordString
    load: (crosswordString) ->
        console.log 'loading from this JSON:', crosswordString
        array = JSON.parse(crosswordString)
        @cells = ((new Cell char for char in row) for row in array.puzzle)

        console.log 'clues:', array.clues
        @clues = array.clues
        #@clues = angular.copy array.clues, @clues
        console.log 'clues loaded:', @clues, @

        @title = 'loaded'
        @author = 'unsure'
        analyseGrid @
    toggleCells = false
    serialise: ->
        stringify_char = (char) ->
            if char == '' then return '@'
            else return char
        stringify_row = (row) ->
            (stringify_char(cell.char) for cell in row).join('')
        puzzle = (stringify_row(row) for row in @cells)
        return angular.toJson
            puzzle: puzzle
            clues: @clues
    random: (width, height) ->
        width = width || 10; height = height || 10
        randomChar = ->
            validChars = '@ABCD'
            validChars[Math.floor( Math.random()*validChars.length )]
        rowGen = (rowIndex, cols) -> (randomChar() for c in [0..cols-1]).join('')
        return JSON.stringify
            puzzle: (rowGen r, width for r in [0..height-1])

class Cell
    constructor: (@char, @num) ->
        if @char is '@'
            @char = ''
            @class = 'black'
    toggle: ->
            if @class is 'black' then @class = ''
            else @class = 'black'

# Here we initiate the Angular module by constructing a
# Crossword object. So initialisation code can be found inside
# Crossword's constructor...
cryptical = angular.module 'cryptical', []
# cryptical.value 'crossword', new Crossword()

cryptical.controller 'CrosswordCtrl', ['$scope',
    ($scope) ->
        $scope.crossword = new Crossword()
        $scope.forceUppercase = (char) ->
            console.log char
            str = 'f'
            @value = str.toUpperCase()
]

cryptical.controller 'CluesCtrl', ['$scope',
    ($scope) ->
        console.log 'initialising clues controller'
]

cryptical.controller 'ButtonsCtrl', ['$scope',
    ($scope) ->
        $scope.load_random = ->
            $scope.crossword.load $scope.crossword.random()
        $scope.load_local = ->
            $scope.crossword.load localStorage['crossword']
        $scope.save_local = ->
            data = $scope.crossword.serialise()
            console.log 'saving this locally:', data
            localStorage['crossword'] = data
]
