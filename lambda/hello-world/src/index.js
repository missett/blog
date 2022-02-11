const helloworld = require("./lib/hello-world");

exports.handler = async function(event, context, callback) {
  return helloworld();
}
