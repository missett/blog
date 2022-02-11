const helloagain = require("./hello-again");

test("check returns hello again", () => {
  expect(helloagain()).toBe("hello, again!");
});
