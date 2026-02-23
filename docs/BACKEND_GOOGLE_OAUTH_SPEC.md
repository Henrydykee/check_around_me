# Backend spec: Google OAuth callback (for mobile app WebView flow)

Send this to your backend developer so they can implement the server side of “Sign in with Google” for the mobile app.

---

## Flow overview

1. User taps “Sign in with Google” in the app → app opens a **WebView** with the Appwrite/Google OAuth URL.
2. User signs in with Google → **Google** redirects to **Appwrite** → **Appwrite** redirects the browser to **your backend** at the “success” URL below.
3. Your backend must: create or find the user, issue our app’s session token (JWT), then **redirect the user’s browser** to a **fixed callback URL** with that token in the query string.
4. The app’s WebView **intercepts** that callback URL, reads the token, closes the WebView, and logs the user in.

---

## 1. URL your backend will receive (entry point)

Appwrite will redirect the user to this URL after successful Google sign-in (you configure this in Appwrite as the “success” redirect):

- **Production:** `https://www.checkaroundme.com/api/auth/oauth-callback`
- **Dev/Beta:** `https://beta.checkaroundme.com/api/auth/oauth-callback`

Query parameters and/or body will be whatever **Appwrite** sends (e.g. state, code, session info). Your backend must:

- Validate the request (e.g. check state, exchange code with Appwrite if needed).
- Identify or create the user (using Appwrite user id / email from the session or token exchange).
- Issue **your app’s JWT** (the same “secret” / session token you use for email/password login).

---

## 2. What your backend must do after creating/finding the user

1. Create or look up the user in your DB (using email or Appwrite user id from the OAuth data).
2. Generate your app’s session token (JWT or whatever you currently return as `secret` for normal login).
3. **Redirect the user’s browser** (HTTP 302) to the **app callback URL** with that token in the query string.

---

## 3. Exact redirect URL (required format)

The app’s WebView is configured to intercept this host + path and read the token from the query string.

**Production:**

```text
https://www.checkaroundme.com/auth/app-callback?secret=YOUR_JWT_HERE
```

**Dev/Beta:**

```text
https://beta.checkaroundme.com/auth/app-callback?secret=YOUR_JWT_HERE
```

- Use **HTTPS**.
- Path must be exactly: **`/auth/app-callback`** (no trailing slash).
- Query parameter: **`secret`** (or **`token`** — the app accepts either name). Value = the same session token (JWT) you return for email/password login (e.g. in `POST /auth/login` response as `secret`).

**Example redirect (pseudo-code):**

```text
302 Redirect
Location: https://www.checkaroundme.com/auth/app-callback?secret=eyJhbGc...
```

---

## 4. Failure case

If something fails (invalid OAuth data, user denied, etc.), redirect to the same path with a failure indicator so the app can show an error (optional; app can also rely on no token = failure):

```text
https://www.checkaroundme.com/auth/app-callback?failure=true
```

(or include `failure=true` and omit `secret` if you want).

---

## 5. Summary checklist for backend

- [ ] Implement (or extend) **GET** (or POST, depending on what Appwrite sends) **`/api/auth/oauth-callback`** for production and, if needed, for beta.
- [ ] Validate Appwrite’s request and get user identity (e.g. email / Appwrite user id).
- [ ] Create or find user in your DB and generate your app’s JWT (“secret”).
- [ ] **Redirect** (302) to **`https://www.checkaroundme.com/auth/app-callback?secret=<JWT>`** (or `https://beta.checkaroundme.com/auth/app-callback?secret=<JWT>` for dev).
- [ ] On failure, redirect to the same path with `failure=true` (and no `secret`) if you want the app to show an error.

---

## 6. App-side contract (for reference)

- The app stores the value of `secret` (or `token`) and uses it as the **Bearer token** for all API requests (`Authorization: Bearer <secret>`).
- The app then calls **`GET /auth/me`** (or your existing “current user” endpoint) to load the user profile, same as after email/password login.

No other backend API changes are required if you already have:

- Login that returns a `secret` (JWT).
- A “current user” endpoint that accepts that token.

If you need the exact Appwrite callback payload (query params/body), check Appwrite’s docs for “OAuth2 callback” or “success redirect” for your Appwrite version.
