var logError = function(error){
  var errorText = new Date().now + ' - ' + error;
  console.log(errorText);
}


module.exports = { logError : logError };
