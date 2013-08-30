cryptical = {}

express = require('express')
app = express()

# static files
app.use express.static(__dirname + '/static')

# templates
jade = require('jade')
fs = require('fs')

# helper for rendering a standard page
render_template = (tpl, opts, req, res, next) ->
    # locate template directory
    filename = __dirname + '/templates/' + tpl + '.jade'
    # compile template function
    template = jade.compile fs.readFileSync( filename ),
        filename: filename
        layout: false
        pretty: true
    # execute template with variables
    html = template opts
    # finish up
    res.writeHead 200,
      'Content-Length': Buffer.byteLength(html),
      'Content-Type': 'text/html'
    res.write(html)
    next()

# views
app.get '/', (req, res, next) ->
    opts =
        contents: 'abc'
    render_template 'home', opts, req, res, next

app.get '/blank', (req, res, next) ->
    opts =
        contents: 'abc'
    render_template 'blank', opts, req, res, next

# API views

# initialise database  
redis = require('redis')
db = redis.createClient(6379, 'incandenza.ucc.asn.au')

# crypto
crypto = require('crypto')
cryptical.hash = (str) ->
    crypto.createHash('sha1').update(str).digest('hex')

app.get '/game/load/:hash', (request, response, next) ->
    db.get request.params.hash, (err, reply) ->
        if reply? then response.send(reply)
        else response.send(404)
        next()

app.get '/game/save', (req, res, next) ->
    res.send 'GET not supported'
    
app.post '/game/save', (req, res, next) ->
    res.send 'thanks for ' + cryptical.hash(req.body) + '!'
    next()

# start app
PORT = 7793
app.listen PORT
console.log 'Express server listening on port ' + PORT + '.'
