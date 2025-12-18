export function saveUser(user){
  localStorage.setItem("cosmic_user", JSON.stringify(user));
}
export function getUser(){
  return JSON.parse(localStorage.getItem("cosmic_user"));
}
export function logout(){
  localStorage.removeItem("cosmic_user");
  location.href="/auth/login.html";
}
