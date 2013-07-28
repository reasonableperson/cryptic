$('#random').click ->
    # validChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ@'
    validChars = ' @'
    randomChar = -> validChars[Math.floor( Math.random()*validChars.length )]
    rowGen = (width) -> (randomChar() for _ in [0..width])
    puzzleGen = (width, height) -> (rowGen(width) for _ in [0..height])
    cryptical.puzzle = new cryptical.Crossword(puzzleGen(15,15))

$('#ajaxLoad').click ->
    $.getJSON 'sample.json', (data) ->
        console.log 'Downloaded this data:', data
        window.puzzle = new cryptical.Crossword(data)
        puzzle.draw()

$('#ajaxSave').click ->
    $.ajax
        url: 'http://localhost:7937/game/save',
        contentType: 'application/json',
        dataType: 'json',
        data: cryptical.puzzle.toJson(),
        type: 'POST',
        success: console.log

$('#localSave').click ->
    if (!Modernizr.localstorage)
        console.error('Your browser doesn\'t support local storage.')
    if (cryptical.puzzle?)
        console.log('Saving this json:', cryptical.puzzle.toJson()) 
        localStorage['puzzle'] = cryptical.puzzle.toJson()
    else console.error('There is no puzzle to save.')

$('#localLoad').click ->
    console.log('Loading this json:', localStorage['puzzle'])
    cryptical.puzzle = new cryptical.Crossword(
        JSON.parse(localStorage['puzzle'])
    )

$('#toggleCells').click ->
    $(@).toggleClass('active')
    $('#crossword').toggleClass('toggleCells')

$('#crossword')
    .on 'click', 'td', ->
        if $('#toggleCells').hasClass('active')
            [row, col] = [$(@).data('row'), $(@).data('col')]
            $(@).toggleClass('black')
            if $(@).hasClass('black')
                cryptical.puzzle.cells[row][col] = '@'
            else
                cryptical.puzzle.cells[row][col] = ' '
    .on 'blur keyup paste', '[contenteditable]', ->
        txt = $.trim($(@).text().toUpperCase())
        if txt.length > 1 then txt = txt.slice(-1)
        $(@).text(txt)
