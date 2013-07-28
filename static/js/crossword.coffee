window.cryptical = {}

# help us build an HTML string for the crossword layout
makeCell = (letter, row, col) ->
    td = "<td contenteditable data-row='" + row + "' data-col='" + col + "'"
    if letter == '@'
        td += " class='black'"
        letter = ''
    td + '>' + letter + '</td>'

makeRow = (letterList, row) ->
    '<tr>' + (makeCell(l, row, col) for l, col in letterList).join('') + '</tr>'

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
