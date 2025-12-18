#!/bin/bash
set -e

echo "🚀 إعداد المرحلة 1 — FOUNDATION"

# إنشاء المجلدات المطلوبة
mkdir -p public/{auth,pages}
mkdir -p public/js/{auth,core}

# ---------------------------
# firebase.js
# ---------------------------
cat > public/js/auth/firebase.js <<'EOF'
import { initializeApp } from "https://www.gstatic.com/firebasejs/10.7.0/firebase-app.js";
import {
  getAuth,
  signInWithEmailAndPassword,
  createUserWithEmailAndPassword,
  sendPasswordResetEmail,
  GoogleAuthProvider,
  signInWithPopup,
  onAuthStateChanged
} from "https://www.gstatic.com/firebasejs/10.7.0/firebase-auth.js";

const firebaseConfig = {
  apiKey: "PUT_YOUR_KEY",
  authDomain: "PUT_DOMAIN",
  projectId: "PUT_ID",
};

export const app = initializeApp(firebaseConfig);
export const auth = getAuth(app);
export {
  signInWithEmailAndPassword,
  createUserWithEmailAndPassword,
  sendPasswordResetEmail,
  GoogleAuthProvider,
  signInWithPopup,
  onAuthStateChanged
};
EOF

# ---------------------------
# session.js
# ---------------------------
cat > public/js/auth/session.js <<'EOF'
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
EOF

# ---------------------------
# guard.js
# ---------------------------
cat > public/js/auth/guard.js <<'EOF'
import { getUser } from "./session.js";
const user = getUser();
if(!user){
  location.href="/auth/login.html";
}
EOF

# ---------------------------
# permissions.js
# ---------------------------
cat > public/js/core/permissions.js <<'EOF'
export function isOverlord(user){
  return user?.role === "overlord";
}
EOF

# ---------------------------
# login.html
# ---------------------------
cat > public/auth/login.html <<'EOF'
<!DOCTYPE html>
<html lang="ar">
<head><meta charset="UTF-8"><title>تسجيل الدخول</title></head>
<body>
<h2>🔐 دخول Cosmic</h2>
<input id="email" placeholder="البريد">
<input id="password" type="password" placeholder="كلمة المرور">
<button onclick="login()">دخول</button>
<button onclick="google()">Google</button>
<a href="reset.html">نسيت كلمة المرور؟</a>

<script type="module">
import { auth, signInWithEmailAndPassword, GoogleAuthProvider, signInWithPopup } from "../js/auth/firebase.js";
import { saveUser } from "../js/auth/session.js";

window.login = async ()=>{
 const email=email.value, pass=password.value;
 const res=await signInWithEmailAndPassword(auth,email,pass);
 saveUser({uid:res.user.uid,email,role:"user"});
 location.href="/pages/index.html";
}
window.google = async ()=>{
 const provider=new GoogleAuthProvider();
 const res=await signInWithPopup(auth,provider);
 saveUser({uid:res.user.uid,email:res.user.email,role:"user"});
 location.href="/pages/index.html";
}
</script>
</body>
</html>
EOF

# ---------------------------
# index.html (الفهرس)
# ---------------------------
cat > public/pages/index.html <<'EOF'
<!DOCTYPE html>
<html lang="ar">
<head><meta charset="UTF-8"><title>Cosmic Index</title></head>
<body>
<h1>🧭 مركز التحكم الكوني</h1>

<ul>
 <li><a href="user.html">👤 لوحة المستخدم</a></li>
 <li><a href="/world/index.html">🌍 العالم</a></li>
 <li><a href="/pages/rooms.html">🏠 الغرف</a></li>
 <li><a href="/pages/labs.html">🔬 المختبرات</a></li>
</ul>

<button onclick="logout()">🚪 خروج</button>

<script type="module">
import "../js/auth/guard.js";
import { logout } from "../js/auth/session.js";
window.logout=logout;
</script>
</body>
</html>
EOF

# ---------------------------
# user.html
# ---------------------------
cat > public/pages/user.html <<'EOF'
<!DOCTYPE html>
<html lang="ar">
<head><meta charset="UTF-8"><title>لوحة المستخدم</title></head>
<body>
<h2>👤 حسابي</h2>
<div id="info"></div>

<script type="module">
import "../js/auth/guard.js";
import { getUser } from "../js/auth/session.js";
const u=getUser();
info.innerHTML=`📧 ${u.email} | 🆔 ${u.uid}`;
</script>
</body>
</html>
EOF

echo "✅ المرحلة 1 اكتملت بنجاح"
