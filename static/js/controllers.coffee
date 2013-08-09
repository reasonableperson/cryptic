###
controllers = angular.module 'controllers', []
    .factory 'Crossword', crosswordController
###
angular.module 'cryptical.controllers', []

.controller 'crosswordController', [ ($scope) ->
    console.log 'invoked crosswordController'
    $scope.cells = puzzleGen 15, 15
    console.log $scope.cells
    $http   .get 'sample.json'
            .success (data) ->
                console.log 'got json:', data
            .failure (data) ->
                console.log 'failed:', data
    ]


puzzleGen = (width, height) ->
    validChars = ' @'
    randomChar = -> validChars[Math.floor( Math.random()*validChars.length )]
    rowGen = (width) -> (randomChar() for _ in [0..width])
    (rowGen(width) for _ in [0..height])
