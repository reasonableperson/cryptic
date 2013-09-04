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

### initialise database  
redis = require('redis')
db = redis.createClient(6379, 'incandenza.ucc.asn.au')

# crypto
crypto = require('crypto')
cryptical.hash = (str) ->
    crypto.createHash('sha1').update(str).digest('hex')
###

# start app
PORT = 7793
app.listen PORT
console.log 'Express server listening on port ' + PORT + '.'

# views
app.get '/', (req, res) ->
    res.render 'puzzle.jade'
