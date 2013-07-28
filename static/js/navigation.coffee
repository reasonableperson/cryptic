# help us navigate the crossword
$.fn.isInvalid = -> @.length == 0 || @.hasClass('black')

$.fn.move = (r, c) -> '' # cell(@.data('row') + r, @.data('col') + c)
$.fn.up = -> @.move(-1, 0)
$.fn.down = -> @.move(1, 0)
$.fn.left = -> @.move(0,-1)
$.fn.right = -> @.move(0,1)

getsNumber = ->
    me = $(@)
    if (me.isInvalid()) then throw "this shouldn't happen" 
    if (me.down() && !me.up() || me.right() && !me.left()) then true
    else false

$('#crossword td:not(.black)').filter(getsNumber).each (i, el) ->
    console.log('filtered', @)
    $('<span class="num">').text(parseInt(i) + 1).appendTo(el)
