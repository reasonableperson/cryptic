# initialise server
restify = require('restify')
server = restify.createServer()
server.use(restify.bodyParser())

# initialise database  
redis = require('redis')
db = redis.createClient(6379, 'incandenza.ucc.asn.au')

# define routes
server.get '/hi', (request, response, next) ->
    response.send('hey')
    next()

server.get '/game/load/:hash', (request, response, next) ->
    db.get request.params.hash, (err, reply) ->
        if reply? then response.send(reply)
        else response.send(404)
        next()

server.post '/game/save', (request, response, next) ->
    # just sends back the body for now
    console.log request.body
    response.send(request.body.foo)
    next()

# start listening
server.listen 7937, 'localhost', ->
    console.log '%s listening at %s', server.name, server.url
