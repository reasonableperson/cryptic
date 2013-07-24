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
