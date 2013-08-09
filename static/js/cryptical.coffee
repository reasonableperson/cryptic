class Cell
    constructor: (@char) ->
        if @char is '@'
            @char = ''
            @class = 'black'

class Crossword
    constructor: (@cells, @title, @author) ->
        if not @cells? then @randomise()
    toJson: -> JSON.stringify(@cells)
    randomise: (width, height) ->
        width = width || 18; height = height || 18
        randomChar = ->
            validChars = '@ABCD'
            validChars[Math.floor( Math.random()*validChars.length )]
        rowGen = (width) -> (new Cell randomChar() for _ in [1..width])
        @cells = (rowGen width for _ in [1..height])
        @title = 'randomly-generated'
        @author = 'anonymous'

cryptical = angular.module 'cryptical', []
cryptical.value 'crossword', new Crossword()


window.CrosswordCtrl = ($scope, crossword) ->
    $scope.crossword = crossword
    # window.crossword = $scope.crossword

###
cryptical.directive 'contenteditable', ->
    require: 'ngModel',
    link: (scope, elm, attrs, ctrl) ->
        # view -> model
        elm.bind 'blur', ->
            scope.$apply ->
                ctrl.$setViewValue elm.html()
 
        # model -> view
        ctrl.$render = (value) -> elm.html value
        # load init value from DOM
        ctrl.$setViewValue elm.html()
###
