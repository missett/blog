import { helloworld } from "./lib/hello-world";

export async function handler(/*event, context, callback*/) {
  return helloworld();
}
