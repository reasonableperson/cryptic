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
    td + letter + '</td>'
makeRow = (letterList, row) -> '<tr>' + (makeCell(l, row, col) for l, col in letterList).join('') + '</tr>'

# draw the crossword
tableStr = (makeRow(str, x) for str, x in PUZZLE).join('')
table = $('<table id="crossword"><tbody>' + tableStr + '</tbody></table>')
$('#crossword').replaceWith(table)

# help us navigate the crossword
window.cell = cell # TODO remove
cell = (row, col) -> $('#crossword td[data-row="'+row+'"][data-col="'+col+'"]')
$.fn.down = -> cell(@.data('row') + 1, @.data('col'))
$.fn.across = -> cell(@.data('row'), @.data('col') + 1)
