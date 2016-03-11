var request = require('request');
var config = require('./config.js');
var errorHandling = require('./errorHandling.js');

module.exports.login = function(req, res){
  var code = req.query.code;

  console.log(config.auth_redirect_url);

  var redirect_uri = config.auth_redirect_url;

  var client_id = '589207933846-pi2p5cinbkn5ipf6skfa0o4om98b8r32.apps.googleusercontent.com';
  var client_secret = 'GC2Io50-TsFTIOXuPfqElUEs';

  var data = { code : code,
    client_id : client_id,
    client_secret : client_secret,
    redirect_uri : redirect_uri,
    grant_type : 'authorization_code'  
  };

  request.post(
    'https://accounts.google.com/o/oauth2/token',
    { form: data },
    function (error, response, body) {
      if (!error && response.statusCode == 200) {

        var data = JSON.parse(body);

        var access_token = data.access_token;
        getUserProfile(access_token, res)

      }
      else { 
        errorHandling.logError(response.body);
        res.render('index', { userId : 'error'  });
      }
    }
  );

}

function getUserProfile(accessToken, res) {

  var url = "https://www.googleapis.com/plus/v1/people/me";

  request.get(url,
              { headers: 
                { 'Authorization': 'Bearer ' + accessToken } 
              },
              function (error, response, body) {
                if (!error && response.statusCode == 200) {
                  var data = JSON.parse(body);
                  console.log('got person: ' + data);
                  saveNewUser(data, res);
                }
                else { 
                  errorHandling.logError(response.body + ' : ' + error);
                  res.render('index', { userId : 'error'  });
                }
              });
}

var saveNewUser = function(user, res){
  var apiUrl = config.api_url;
  var url = apiUrl + "/addUser/" + user.emails[0].value;
  console.log(url);

  request.post(url, { form : user },
               function(error, response, body){
                 if (!error){
                   console.log('body: ' + body);
                   var user = JSON.parse(body);
                   res.render('index', { userId : user.id  })
                 }
                 else {
                   errorHandling.logError(error);
                   res.render('index', { userId : 'error'  })
                 }
               });
};
