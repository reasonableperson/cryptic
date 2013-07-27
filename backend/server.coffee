cryptical = {}

# initialise server
restify = require('restify')
server = restify.createServer()
server.use restify.bodyParser()
server.use restify.fullResponse()
#server.use (req, res, next) ->
#    next()

# initialise database  
redis = require('redis')
db = redis.createClient(6379, 'incandenza.ucc.asn.au')

# crypto
crypto = require('crypto')
cryptical.hash = (str) ->
    crypto.createHash('sha1').update(str).digest('hex')

# define routes
server.get '/hi', (request, response, next) ->
    response.send('hey')
    next()

server.get '/game/load/:hash', (request, response, next) ->
    db.get request.params.hash, (err, reply) ->
        if reply? then response.send(reply)
        else response.send(404)
        next()

server.get '/game/save', (req, res, next) ->
    res.send 'fuck you'
    
server.post '/game/save', (req, res, next) ->
    res.header "Access-Control-Allow-Origin", "http://localhost:7793"
    res.header "Access-Control-Allow-Headers", "X-Requested-With"
    res.send 'thanks for ' + cryptical.hash(req.body) + '!'
    next()

# start listening
server.listen 7937, 'localhost', ->
    console.log '%s listening at %s', server.name, server.url
