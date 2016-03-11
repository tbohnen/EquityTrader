#!/usr/bin/env node


var fs = require("fs");
var path = require("path");
var rootdir = process.argv[2];

console.log("Running hook: "+path.basename(process.env.CORDOVA_HOOK));
 
if (process.env.TARGET) {
    var srcfile = path.join(rootdir, "config", "config-"+process.env.TARGET+".js");
 
    //do this for each platform
    var configFilesToReplace = {
      "android" : "platforms/android/assets/www/js/config.js"
    };

    for(var platform in configFilesToReplace) {
      console.log("Modifying config for platform "+platform+", TARGET="+process.env.TARGET);
      var destfile = path.join(rootdir, configFilesToReplace[platform]);

      if (!fs.existsSync(srcfile)) {
        console.log("Missing config file: "+srcfile);
      } else {
        console.log("copying "+srcfile+" to "+destfile);
          fs.createReadStream(srcfile).pipe(fs.createWriteStream(destfile));
      }
    }
} else {
  console.log("TARGET environment variable is not set.  Using default values.");
} 
