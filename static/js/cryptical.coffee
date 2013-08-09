angular.module 'cryptical', []
###.config '$routeProvider', ($routeProvider) ->
        $routeProvider.when '/', 
            templateUrl: 'foo.html'
            controller: 'foo'
###
#

puzzleGen = (width, height) ->
    validChars = ' @'
    randomChar = -> validChars[Math.floor( Math.random()*validChars.length )]
    rowGen = (width) -> (randomChar() for _ in [1..width])
    result = (rowGen(width) for _ in [1..height])

window.CrosswordCtrl = ($scope) ->
    $scope.cells = puzzleGen(10,10)

# help us build an HTML string for the crossword layout
makeCell = (letter, row, col) ->
    td = "<td contenteditable data-row='" + row + "' data-col='" + col + "'"
    if letter == '@'
        td += " class='black'"
        letter = ''
    td + '>' + letter + '</td>'

makeRow = (letterList, row) ->
    '<tr>' + (makeCell(l, row, col) for l, col in letterList).join('') + '</tr>'

###
cryptical.Crossword = class Crossword
    constructor: (@cells) -> @.draw()
    draw: ->
        tableStr = (makeRow(str, x) for str, x in @cells).join('')
        $('#crossword tbody').html(tableStr)
    toJson: -> JSON.stringify(@cells)
    cell: (row, col) ->
        result = $('#crossword td[data-row="'+row+'"][data-col="'+col+'"]')
        if (result.isInvalid()) then false
        else result
###
