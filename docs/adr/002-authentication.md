# ADR-002 amendment — Supabase authentication and local data ownership

Date: 2026-10-02. Status: accepted authentication direction; access policy and email method pending user input.

The user requires Apple, Google and email signup/login. Use Supabase Auth as the managed identity service through the official Swift SDK. A custom authentication server is unnecessary; protected administrative operations such as account deletion may require a small server function.

This supersedes the original plan's assumption that product accounts and a backend were unnecessary. Preserve local timer/history and the pure domain boundaries. Whether login is mandatory or optional local use is allowed remains undecided and must be confirmed before gating the app.

Use native AuthenticationServices for Apple ID-token sign-in, ASWebAuthenticationSession with PKCE for Google via Supabase, and the user-selected email method. Isolate network/provider behavior behind an AuthRepository, and store session credentials in Keychain through a supported SDK adapter. Add account-scoped data ownership before shipping login.

Authentication does not select a cloud sync backend or authorize history/activity uploads. Step 16 must choose Supabase/Postgres or a separate private CloudKit identity and record the tradeoff. FocusDomain and audio rendering must have no Supabase dependency.

Consequences: provider configuration, Apple signing/capabilities, callbacks, secure session lifecycle, production email delivery, account switching/isolation and deletion become release gates. Public client configuration is safe to embed; provider/administrative secrets remain on the server. See [authentication design](../AUTHENTICATION.md) and [Step 18](../../Agents/TASKS.md).
