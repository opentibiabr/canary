# LoginSessionManager

## What this is

`LoginSessionManager` (`src/security/login_session_manager.hpp/.cpp`) is an in-memory,
single-use token store for bridging the login connection to the game connection
without re-sending the account password. It exists to replace the ad-hoc
"session key" string that `ProtocolLogin::getCharacterList` currently builds as
`accountDescriptor + "\n" + password` (see `docs/systems/multiprotocol.md`) with
a real cryptographically random token.

Properties:

- 256-bit token, generated with an mbedTLS CTR-DRBG CSPRNG (same pattern as
  `src/security/rsa_backend_mbedtls.cpp`), hex-encoded for the wire.
- Only the token's SHA-256 hash is ever stored; the raw value is returned once,
  at issuance, and never persisted.
- Single-use: redemption removes the matching entry before validating anything
  else about it, so a wrong character name still burns the token (an attacker
  who intercepts a token in flight gets exactly one guess), and two concurrent
  redemption attempts for the same token can never both succeed.
- Bound at issuance to the account id, the full set of character names the
  account is allowed to pick from (the login connection doesn't know which
  character the client will choose yet), and the resolved `ProtocolProfileId`.
- TTL-bounded (default 60s) and capped at a maximum number of active tokens
  (default 4096, oldest evicted first) so a burst of logins can't grow the
  store unboundedly.
- Hash comparison during redemption is constant-time (branchless XOR-accumulate
  over the full digest) to avoid leaking partial matches through timing.
- The token is **not** bound to the client's IP address. IP can still be used
  elsewhere as an additional signal (rate limiting, ban lists), just not as
  part of what makes a token valid.

## Current status: built and tested, not yet wired in

This PR ships the manager and its test suite in isolation. It is **not yet**
called from `ProtocolLogin`/`ProtocolGame` — wiring it into the live
authentication path touches the exact code that decides whether a connection
is allowed to play, so it's being done as a separate, focused follow-up PR
that can be reviewed (and reverted) independently of this primitive.

## Where the token can actually go on the wire

The login response already has a field built for exactly this: packet `0x28`
sends an opaque string (`AccountLoginLayout::sendsSessionKey`), and the game
login packet reads one back (`GameLoginAuthenticationLayout::SessionKey`). The
client never interprets this value; it just echoes back whatever the server
sent it, which is what makes it safe to fill with an opaque random token
instead of `account + "\n" + password`.

That field is not universally available:

- **Old-protocol clients** (`AccountLoginLayout`/`GameLoginAuthenticationLayout
  == AccountPassword`, e.g. the 8.60 family) have no session-key field at all
  — they send the account descriptor and password directly on every
  connection, login and game alike. There is nothing to replace here; this is
  the explicit legacy-compatibility path and it keeps working exactly as it
  does today.
- **Modern clients with `authType == "password"`** (the project default) send
  the session-key string back on the game connection, but
  `ProtocolGame::onRecvFirstMessage` only skips its `account\npassword` split
  logic when `authType == "session"`. A random token has no embedded `\n`, so
  under the default config it would fail that split and get rejected as "you
  must enter your username" — this mode re-validates the real password on the
  game connection today and is out of scope for the token.
- **Modern clients with `authType == "session"`** are exactly the existing
  code path this integrates with: `IOLoginData::gameWorldAuthentication` already
  skips password re-validation in this mode and instead calls
  `Account::authenticate()`, which today falls through to the DB-backed
  `account_sessions` table (`Account::load()` → `loadBySession`). The planned
  follow-up adds `LoginSessionManager::issueToken`/`consumeToken` as a check
  *ahead of* that DB lookup, for connections whose resolved `ProtocolProfileId`
  actually sent a session-key field. The DB-backed table is left untouched —
  it also serves standalone login-panel/launcher integrations that mint their
  own long-lived sessions outside of `ProtocolLogin`, which is a different use
  case from this per-login-handshake token.

## Known limitation

Because of the above, this token only ever protects the
`authType == "session"` + non-old-protocol + `SessionKey`-layout path. Every
other combination keeps its current behavior unchanged. This is the "explicit
compatibility layer for older protocols" called out as a requirement: it's not
a gap introduced by this change, it's the wire reality of what those clients
can carry.
