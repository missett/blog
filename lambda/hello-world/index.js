exports.handler = async function(event, context, callback) {
  console.log("EVENT: " + JSON.stringify(event));
  return "hello, world!";
}
