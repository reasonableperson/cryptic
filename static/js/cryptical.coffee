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
    clues = crossword.clues = {across: {}, down: {}}
    cells = crossword.cells
    for row, i in cells
        for cell, j in row when cell.class isnt 'black'
            up = if i > 0 then (cells[i-1][j].class isnt 'black') else false
            down = if i+1 < cells.length then (cells[i+1][j].class isnt 'black') else false
            left = if j > 0 then (row[j-1].class isnt 'black') else false
            right = if j+1 < row.length then (row[j+1].class isnt 'black') else false
            if right and not left   # across clue
                cell.num = ++counter
                clues.across[cell.num] = new Clue(countAnswerLength cells, i, j, 'across')
            if down and not up      # down clue
                if not right or left
                    cell.num = ++counter
                clues.down[cell.num] = new Clue(countAnswerLength cells, i, j, 'down')

class Crossword
    constructor: (array) ->
        if not array? then @load(@random())
        else @load(array)
    toggleCells = false
    load: (array) -> 
        console.log 'constructing from this array', array
        @cells = ((new Cell char for char in row) for row in array)
        @title = 'loaded'
        @author = 'unsure'
        analyseGrid @
    serialise: ->
        stringify_char = (char) ->
            if char == '' then return '@'
            else return char
        stringify_row = (row) ->
            (stringify_char(cell.char) for cell in row).join('')
        puzzle_str = (stringify_row(row) for row in @cells)
        angular.toJson puzzle_str
    random: (width, height) ->
        width = width || 10; height = height || 10
        randomChar = ->
            validChars = '@ABCD'
            validChars[Math.floor( Math.random()*validChars.length )]
        rowGen = (rowIndex, cols) -> (randomChar() for c in [0..cols-1]).join('')
        @cells = (rowGen r, width for r in [0..height-1])

class Cell
    constructor: (@char, @num) ->
        if @char is '@'
            @char = ''
            @class = 'black'
    toggle: ->
            if @class is 'black' then @class = ''
            else @class = 'black'

class Clue
    constructor: (@length, @text) ->
        if not @text then @text = '(placeholder)'

# Here we initiate the Angular module by constructing a
# Crossword object. So initialisation code can be found inside
# Crossword's constructor...
cryptical = angular.module 'cryptical', []
cryptical.value 'crossword', new Crossword()

cryptical.controller 'CrosswordCtrl', ['$scope', '$http', 'crossword',
    ($scope, $http, crossword) ->
        $scope.crossword = crossword
        $scope.forceUppercase = (char) ->
            console.log char
            str = 'f'
            @value = str.toUpperCase()
]

cryptical.controller 'CluesCtrl', ['$scope', 'crossword',
    ($scope, crossword) ->
        $scope.crossword = crossword
]

cryptical.controller 'ButtonsCtrl', ['$scope', 'crossword',
    ($scope, crossword) ->
        $scope.crossword = crossword
        $scope.load = (url) ->
            $http.get(url)
            .success (data, status, headers, config) ->
                console.log 'got json:', data, typeof(data)
                $scope.crossword = new Crossword(data)
            .error (data, status, headers, config) ->
                console.error status, data
        $scope.load_random = -> crossword.load crossword.random()
        $scope.save = ->
            console.log 'sending the following:', crossword.serialise()
            $http.post('/game/save')
            .success (data) ->
                console.log 'got response:', data, typeof(data)
            .error (data, status, headers, config) ->
                console.error status, data
        $scope.load_local = ->
            data = JSON.parse localStorage['crossword']
            crossword.load(data)
        $scope.save_local = ->
            data = crossword.serialise()
            console.log 'saving this locally:', data
            localStorage['crossword'] = data
]
