class Cell
    constructor: (@char) ->
        if @char is '@'
            @char = ''
            @class = 'black'

class Crossword
    constructor: (@cells, @title, @author) ->
        if not @cells? then @randomise()
    toJson: -> JSON.stringify(@cells)
    randomise: (width, height) ->
        width = width || 18; height = height || 18
        randomChar = ->
            validChars = '@ABCD'
            validChars[Math.floor( Math.random()*validChars.length )]
        rowGen = (width) -> (new Cell randomChar() for _ in [1..width])
        @cells = (rowGen width for _ in [1..height])
        @title = 'randomly-generated'
        @author = 'anonymous'

cryptical = angular.module 'cryptical', []
cryptical.value 'crossword', new Crossword()

cryptical.controller 'CrosswordCtrl', [
    '$scope', '$http', 'crossword',
    ($scope, $http, crossword) ->
        window.$scope = $scope
        $scope.crossword = crossword
        $scope.load = (url) ->
            $http.get(url)
            .success (data, status, headers, config) ->
                console.log data
            .error (data, status, headers, config) ->
                console.log data
]

cryptical.directive 'oneCharOnly', -> 
    return (scope, elem, attrs) -> elem
        .click ->
            @select()
        .change ->
            @value = @value.toUpperCase()
