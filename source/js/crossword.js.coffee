window.cryptical = {}

# help us build an HTML string for the crossword layout
makeCell = (letter, row, col) ->
    td = "<td data-row='" + row + "' data-col='" + col + "'"
    if letter == '@' then td += " class='black'"
    td + '>' + letter + '</td>'
makeRow = (letterList, row) -> '<tr>' + (makeCell(l, row, col) for l, col in letterList).join('') + '</tr>'

# draw the crossword
drawPuzzle = (json) ->
    # console.log(json)
    puzzle = (str.split('') for str in json)
    tableStr = (makeRow(str, x) for str, x in puzzle).join('')
    table = $('<table id="crossword"><tbody>' + tableStr + '</tbody></table>')
    $('#crossword').replaceWith(table)

cryptical.Crossword = class Crossword
    constructor: (@cells) -> @.draw()
    draw: ->
        tableStr = (makeRow(str, x) for str, x in @cells).join('')
        table = $('<table id="crossword"><tbody>' + tableStr + '</tbody></table>')
        $('#crossword').replaceWith(table)
    toJson: -> JSON.stringify(@cells)

getsNumber = ->
    me = $(@)
    if (me.isInvalid()) then throw "this shouldn't happen" 
    if (me.down() && !me.up() || me.right() && !me.left()) then true
    else false

$('#crossword td:not(.black)').filter(getsNumber).each( (i, el) ->
    console.log('filtered', @)
    $('<span class="num">').text(parseInt(i) + 1).appendTo(el)
)

