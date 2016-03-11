var env = process.env.NODE_ENV || 'dev';

var config = {
  auth_redirect_url : 'http://localhost:3001/authorized',
  port : 3001,
  api_url : "http://localhost:8080/" };

if (env == "production"){
  config.auth_redirect_url = '';
    config.api_url = "";
  port : 3007;
}

if (env == "demo"){
  config.auth_redirect_url = '';
    config.api_url = "";
}

module.exports = config;
