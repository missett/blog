const helloagain = require("./lib/hello-again");

exports.handler = async function(event, context, callback) {
  return helloagain();
}
