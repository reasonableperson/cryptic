$('#random').click(->
    # validChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ@'
    validChars = ' @'
    randomChar = -> validChars[Math.floor( Math.random()*validChars.length )]
    rowGen = (width) -> (randomChar() for _ in [0..width])
    puzzleGen = (width, height) -> (rowGen(width) for _ in [0..height])
    cryptical.puzzle = new cryptical.Crossword(puzzleGen(10,10))
)

$('#ajaxLoad').click(->
    $.getJSON('sample.json', (data) ->
        console.log('Downloaded this data:', data)
        window.puzzle = new cryptical.Crossword(data)
        puzzle.draw()
        if (Modernizr.localstorage)
            localStorage['puzzle'] = puzzle.toJson()
    )
)

$('#localSave').click(->
    if (!Modernizr.localstorage)
        console.error('Your browser doesn\'t support local storage.')
    if (cryptical.puzzle?)
        console.log('Saving this json:', cryptical.puzzle.toJson()) 
        localStorage['puzzle'] = cryptical.puzzle.toJson()
    else console.error('There is no puzzle to save.')
)
$('#localLoad').click(->
    console.log('Loading this json:', localStorage['puzzle'])
    cryptical.puzzle = new cryptical.Crossword(
        JSON.parse(localStorage['puzzle'])
    )
)
