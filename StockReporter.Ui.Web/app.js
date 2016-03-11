var express = require('express'),
stylus = require('stylus'),
nib = require('nib'),
http = require('http'),
reload = require('reload'),
request = require('request'),
googleLogin = require('./googleLogin.js'),
config = require('./config.js')


var app = express()
function compile(str, path) {
  return stylus(str)
  .set('filename', path)
  .use(nib())
}

app.set('views', __dirname + '/views')
app.set('view engine', 'jade')

app.use(express.logger('dev'))

app.use(stylus.middleware(
  { src: __dirname + '/public'
  , compile: compile
}
))

app.use(express.static(__dirname + '/public'))

var server = http.createServer(app)
reload(server, app)
app.listen(config.port)

app.get('/', function(req, res){
  res.render('index', { title : 'Welcome', userId : ''  })
})


app.get('/authorized', function(req, res){
  googleLogin.login(req, res);
})

app.get('/MyWatchlist', function(req, res){
  res.render('myWatchlist');
});
app.get('/MyShares', function(req, res){
  res.render('myShares');
});

app.get('/Reports', function(req, res){
  res.render('reports');
});

app.get('/Charts', function(req, res){
    res.render('charts');
});
