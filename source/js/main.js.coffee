console.log('running main.js')

# help us generate a random puzzle
# validChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ@'
validChars = ' @'
randomChar = -> validChars[Math.floor( Math.random()*validChars.length )]
rowGen = (width) -> (randomChar() for i in [0..width])
puzzleGen = (width, height) -> (rowGen(width) for i in [0..height])

# load the puzzle object
PUZZLE = puzzleGen(10,10)

# help us build a string for the crossword layout
makeCell = (letter) -> 
    if letter == '@' then "<td class='black'></td>"
    else '<td contenteditable>' + letter + '</td>'
makeRow = (letterList) -> '<tr>' + (makeCell(l) for l in letterList).join() + '</tr>'
tableStr = (makeRow(str) for str in PUZZLE).join()

# 
table = $('<table id="crossword"><tbody></tbody></table>')
table.append(tableStr)
$('#crossword').replaceWith(table)
