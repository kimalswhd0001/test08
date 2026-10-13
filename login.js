// 데모용 계정 목록 (실제 서비스에서는 서버에서 인증해야 합니다)
const USERS = {
  admin: "1234",
  user: "user1234"
};

const $ = (id) => document.getElementById(id);

// 저장소 접근이 막힌 환경(사생활 보호 모드 등)에서도 동작하도록 감싸기
const store = {
  get(area, key) { try { return window[area].getItem(key); } catch { return null; } },
  set(area, key, val) { try { window[area].setItem(key, val); } catch {} },
  remove(area, key) { try { window[area].removeItem(key); } catch {} }
};
const form = $("loginForm");
const userIdInput = $("userId");
const passwordInput = $("password");
const msg = $("msg");

// 저장된 아이디 / 로그인 세션 복원
window.addEventListener("DOMContentLoaded", () => {
  const savedId = store.get("localStorage", "savedId");
  if (savedId) {
    userIdInput.value = savedId;
    $("remember").checked = true;
  }
  const loggedIn = store.get("sessionStorage", "loginUser");
  if (loggedIn) showWelcome(loggedIn);
});

// 비밀번호 보기/숨기기
$("togglePw").addEventListener("click", () => {
  const hidden = passwordInput.type === "password";
  passwordInput.type = hidden ? "text" : "password";
  $("togglePw").textContent = hidden ? "숨기기" : "보기";
});

$("findPw").addEventListener("click", (e) => {
  e.preventDefault();
  alert("비밀번호 찾기 기능은 준비 중입니다.");
});

function validate() {
  let ok = true;
  const id = userIdInput.value.trim();
  const pw = passwordInput.value;

  $("userIdErr").textContent = "";
  $("passwordErr").textContent = "";
  userIdInput.classList.remove("invalid");
  passwordInput.classList.remove("invalid");

  if (!id) {
    $("userIdErr").textContent = "아이디를 입력해 주세요.";
    userIdInput.classList.add("invalid");
    ok = false;
  }
  if (!pw) {
    $("passwordErr").textContent = "비밀번호를 입력해 주세요.";
    passwordInput.classList.add("invalid");
    ok = false;
  }
  return ok;
}

form.addEventListener("submit", (e) => {
  e.preventDefault();
  msg.textContent = "";
  msg.className = "msg";
  if (!validate()) return;

  const id = userIdInput.value.trim();
  const pw = passwordInput.value;
  const btn = $("submitBtn");
  btn.disabled = true;
  btn.textContent = "확인 중...";

  // 서버 요청을 흉내 내는 지연
  setTimeout(() => {
    btn.disabled = false;
    btn.textContent = "로그인";

    if (USERS[id] && USERS[id] === pw) {
      if ($("remember").checked) store.set("localStorage", "savedId", id);
      else store.remove("localStorage", "savedId");

      store.set("sessionStorage", "loginUser", id);
      msg.textContent = "로그인 성공!";
      msg.classList.add("success");
      setTimeout(() => showWelcome(id), 500);
    } else {
      msg.textContent = "아이디 또는 비밀번호가 올바르지 않습니다.";
      msg.classList.add("error");
      passwordInput.value = "";
      passwordInput.focus();
    }
  }, 600);
});

function showWelcome(id) {
  $("loginSection").style.display = "none";
  $("welcome").style.display = "block";
  $("welcomeName").textContent = id;
}

$("logoutBtn").addEventListener("click", () => {
  store.remove("sessionStorage", "loginUser");
  $("welcome").style.display = "none";
  $("loginSection").style.display = "block";
  passwordInput.value = "";
  msg.textContent = "로그아웃되었습니다.";
  msg.className = "msg";
});
