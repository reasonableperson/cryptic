# help us generate a random puzzle
# validChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ@'
validChars = ' @'
randomChar = -> validChars[Math.floor( Math.random()*validChars.length )]
rowGen = (width) -> (randomChar() for i in [0..width])
puzzleGen = (width, height) -> (rowGen(width) for i in [0..height])

# load the puzzle object
PUZZLE = puzzleGen(10,10)

# help us build an HTML string for the crossword layout
makeCell = (letter, row, col) ->
    td = "<td data-row='" + row + "' data-col='" + col + "'"
    if letter == '@' then td += " class='black'"
    td + '>' + letter + '</td>'
makeRow = (letterList, row) -> '<tr>' + (makeCell(l, row, col) for l, col in letterList).join('') + '</tr>'

# draw the crossword
tableStr = (makeRow(str, x) for str, x in PUZZLE).join('')
table = $('<table id="crossword"><tbody>' + tableStr + '</tbody></table>')
$('#crossword').replaceWith(table)

# help us navigate the crossword
$.fn.isInvalid = -> @.length == 0 || @.hasClass('black')
cell = (row, col) ->
    result = $('#crossword td[data-row="'+row+'"][data-col="'+col+'"]')
    if (result.isInvalid()) then false
    else result
$.cell = cell # TODO remove

$.fn.move = (r, c) -> cell(@.data('row') + r, @.data('col') + c)
$.fn.up = -> @.move(-1, 0)
$.fn.down = -> @.move(1, 0)
$.fn.left = -> @.move(0,-1)
$.fn.right = -> @.move(0,1)

# toggle black/white on click (for now)
$('#crossword').on('click', 'td', -> $(@).toggleClass('black'))

getsNumber = ->
    me = $(@)
    if (me.isInvalid()) then throw "this shouldn't happen" 
    if (me.down() && !me.up() || me.right() && !me.left()) then true
    else false

$('#crossword td:not(.black)').filter(getsNumber).each( (i, el) ->
    $('<span class="num">').text(parseInt(i) + 1).appendTo(el)
)



