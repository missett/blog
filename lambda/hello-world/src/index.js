const helloworld = require("./lib/hello-world");

exports.handler = async function (event, context, callback) {
  return { statusCode: 200, body: helloworld() };
};
