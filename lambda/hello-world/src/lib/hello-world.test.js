import { test, expect } from "@jest/globals";
import { helloworld } from "./hello-world";

test("check returns hello world", () => {
  expect(helloworld()).toBe("hello, world!");
});
