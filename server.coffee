cryptical = {}

express = require 'express'
app = express()

# render stylus to CSS
app.use(require('stylus').middleware(__dirname + '/static'));

# render jade to HTML
app.set 'views', __dirname + '/templates'
app.engine 'jade', require('jade').__express

# static files
app.use express.static(__dirname + '/static')

# sqlite
sqlite3 = require('sqlite3').verbose()
db = new sqlite3.Database './development.db'
db.serialize -> # run a test query
    db.each 'select * from sqlite_master;', (err, row) ->
        #console.log row

# start app
PORT = 7793
app.listen PORT
console.log 'Express server listening on port ' + PORT + '.'

# log all http requests
connect = require 'connect'
app.use connect.logger()

### VIEWS ###

# home page
app.get '/', (req, res) ->
    res.render '2col.jade'

# API: list all puzzles in the database
app.post '/api/listCrosswords', (req, res) ->
    res.set 'Content-Type', 'application/json'
    res.write '[\n\n'
    db.each 'select * from crosswords;', (err, row) ->
        res.write row.grid_json + ',\n\n'
    , ->
        res.write ']'
        res.end()

app.post '/api/getCrossword/:id', (req, res) ->
    console.log 'get crossword id=', req.params.id
    db.run 'select * from crosswords where id = ?', req.params.id, (err, row) ->
        if err then console.error err
        if not row? then res.send 404, 'there is no crossword with id ' + req.params.id + '...'
        else res.send JSON.stringify(row)
