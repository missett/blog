const helloworld = require("./hello-world");

test("check returns hello world", () => {
  expect(helloworld()).toBe("hello, world!");
});
