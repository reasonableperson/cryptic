cryptical = {}

# initialise server
restify = require('restify')
server = restify.createServer()
server.use restify.bodyParser()
server.use restify.fullResponse()

express = require('express')
app = express()

# static files
app.use express.static(__dirname + '/static')

# templates
jade = require('jade')
fs = require('fs')
template_filename = (name) -> __dirname + '/templates/' + name + '.jade'

app.get '/', (request, response, next) ->
    template = jade.compile fs.readFileSync( template_filename 'home' ),
        filename: template_filename 'home'
        layout: false
        pretty: true
    html = template
        contents: 'abc'
    response.writeHead 200,
      'Content-Length': Buffer.byteLength(html),
      'Content-Type': 'text/html'
    response.write(html)
    next()

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

PORT = 7937
app.listen PORT
console.log 'Express server listening on port ' + PORT + '.'
