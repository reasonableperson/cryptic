class Cell
    constructor: (@row, @col, @char, @num) ->
        if @char is '@'
            @char = ''
            @class = 'black'

class Crossword
    constructor: (array) ->
        if not array? then @randomise()
        else
            @cells = ((new Cell r, c, char for c, char in row) for r, row in array)
        @current = [0,0]
        @number()
    number: ->
        counter = 0
        @clues = {across: {}, down: {}}
        for row, i in @cells
            for cell, j in row when cell.class isnt 'black'
                up = if i > 0 then (@cells[i-1][j].class isnt 'black') else false
                down = if i+1 < @cells.length then (@cells[i+1][j].class isnt 'black') else false
                left = if j > 0 then (row[j-1].class isnt 'black') else false
                right = if j+1 < row.length then (row[j+1].class isnt 'black') else false
                if right and not left
                    cell.num = ++counter
                    @clues.across[cell.num] = ""
                if down and not up
                    if not right or left then cell.num = ++counter
                    @clues.down[cell.num] = ""
        console.log 'after analysis, cells:', @cells
        console.log 'clues:', @clues
    move: (inRow, acrossRows) ->
        @current[0] += inRow; @current[1] += acrossRows;
        @cells[@current[0]][@current[1]]
    down: -> @cells[@current[0]+1][@current[1]]
    across: -> @cells[@current[0]][@current[1]+1]
    toJson: -> JSON.stringify(@cells)
    randomise: (width, height) ->
        width = width || 10; height = height || 10
        randomChar = ->
            validChars = '@ABCD'
            validChars[Math.floor( Math.random()*validChars.length )]
        rowGen = (rowIndex, cols) -> (new Cell rowIndex, c, randomChar() for c in [0..cols-1])
        @cells = (rowGen r, width for r in [0..height-1])
        @title = 'randomly-generated'
        @author = 'anonymous'

cryptical = angular.module 'cryptical', []
cryptical.value 'crossword', new Crossword()

cryptical.controller 'CrosswordCtrl', ['$scope', '$http', 'crossword',
    ($scope, $http, crossword) ->
        window.$scope = $scope
        $scope.crossword = crossword
        $scope.load = (url) ->
            $http.get(url)
            .success (data, status, headers, config) ->
                console.log 'got json:', data, typeof(data)
                $scope.crossword = new Crossword(data)
            .error (data, status, headers, config) ->
                console.error status, data
        $scope.save = ->
            $http.post('/game/save')
            .success (data) ->
                console.log 'got response:', data, typeof(data)
            .error (data, status, headers, config) ->
                console.error status, data
        $scope.number = ->
            for cell of crossword.cells
                console.log cell
]

cryptical.directive 'oneCharOnly', -> 
    return ($scope, elem, attrs) -> elem
        .on 'click keyup', ->
            @select()
            $scope.$parent.$parent.crossword.current = [$scope.$parent.$index, $scope.$index]
            console.log $scope.$parent.$parent.crossword.current
        .change ->
            @value = @value.toUpperCase()
