angular.module 'cryptical', []
###.config '$routeProvider', ($routeProvider) ->
        $routeProvider.when '/', 
            templateUrl: 'foo.html'
            controller: 'foo'
###
class Cell
    constructor: (@char) ->
        if @char is '@'
            @char = ''
            @class = 'black'

class Crossword
    constructor: (@cells, @title, @author) ->
    toJson: -> JSON.stringify(@cells)

puzzleGen = (width, height) ->
    validChars = ' @'
    randomChar = -> validChars[Math.floor( Math.random()*validChars.length )]
    rowGen = (width) -> (new Cell(randomChar()) for _ in [1..width])
    (rowGen width for _ in [1..height])

window.CrosswordCtrl = ($scope) ->
    # fake crossword
    $scope.crossword = new Crossword puzzleGen(10,10), 'randomly-generated crossword', 'fate'
    window.crossword_temp = $scope.crossword
