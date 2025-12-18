const state={name:"",role:"guest",gold:0,energy:100,xp:0};
function login(){const u=document.getElementById("user").value.trim();
 if(!u)return alert("أدخل اسم");state.name=u;
 document.getElementById("auth").hidden=true;
 document.getElementById("hud").hidden=false;}
