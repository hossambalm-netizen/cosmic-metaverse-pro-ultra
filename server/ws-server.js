const WebSocket=require('ws');const fs=require('fs');
const wss=new WebSocket.Server({port:8080});
let users=0;
wss.on('connection',ws=>{
 users++;ws.send(JSON.stringify({type:'welcome',users}));
 ws.on('close',()=>users--);
});
console.log("✅ WS server ULTRA running on ws://localhost:8080");
