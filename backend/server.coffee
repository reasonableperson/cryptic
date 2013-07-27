cryptical = {}

# initialise server
restify = require('restify')
server = restify.createServer()
server.use restify.bodyParser()
server.use restify.fullResponse()

# initialise database  
redis = require('redis')
db = redis.createClient(6379, 'incandenza.ucc.asn.au')

# crypto
crypto = require('crypto')
cryptical.hash = (str) ->
    crypto.createHash('sha1').update(str).digest('hex')

# templates
haml = require('haml')
fs = require('fs')
server.get '/', (request, response, next) ->
    template = fs.readFileSync('template.haml').toString().split('\n')
    html = haml.render template,
        contents: 'abc'
    response.writeHead 200,
      'Content-Length': Buffer.byteLength(html),
      'Content-Type': 'text/html'
    response.write(html).end()
    next()

server.get '/game/load/:hash', (request, response, next) ->
    db.get request.params.hash, (err, reply) ->
        if reply? then response.send(reply)
        else response.send(404)
        next()

server.get '/game/save', (req, res, next) ->
    res.send 'GET not supported'
    
server.post '/game/save', (req, res, next) ->
    res.header "Access-Control-Allow-Origin", "http://localhost:7793"
    res.header "Access-Control-Allow-Headers", "X-Requested-With"
    res.send 'thanks for ' + cryptical.hash(req.body) + '!'
    next()

# start listening
server.listen 7937, 'localhost', ->
    console.log '%s listening at %s', server.name, server.url
