import { getUser } from "./session.js";
const user = getUser();
if(!user){
  location.href="/auth/login.html";
}
