# Client 15.25 compatibility update

This document describes the scope of the 15.25 client compatibility update for
Canary. The change is a byte-contract update for the current client model. It
is not a complete gameplay feature implementation.

## Intent

The goal is to keep Canary aligned with the current client message contract so
sessions can login and keep running without client debugs caused by missing or
misaligned bytes.

This PR should be reviewed as byte compatibility support:

- update the current runtime profile to advertise confirmed 15.25 message
  capabilities;
- send and parse the bytes expected by the current client;
- keep new message shapes behind runtime feature flags;
- provide minimal Lua module shims where a full server-side system does not
  exist yet.

## Non-goals

This PR intentionally does not implement the full gameplay systems behind the
new messages.

The following are out of scope unless a later PR adds them explicitly:

- full state, rewards, rerolls, shop contents, persistence, or balancing for
  the new list window;
- full progression or arena behavior for the new side dialog;
- complete gameplay behavior for the new vocation/skill side payloads beyond
  byte compatibility;
- new monetization/store offers;
- broad gameplay rewrites unrelated to the 15.25 byte contract.

## Runtime model

The update follows Canary's runtime profile model. Message differences are
gated through runtime feature flags instead of scattered raw version checks.

That keeps older profiles from receiving current-only bytes while allowing the
current profile to match the 15.25 client shape.

Some runtime flags used by the current profile can predate 15.25. For example,
`GameEventPayload` is a 15.13+ payload contract for server packet
`0x75`; it is enabled here because the 15.25 current profile also requires that
shape. Keep the first confirmed version documented in
[Multiprotocol runtime profiles](multiprotocol.md).

## Minimal byte shims

Some current-client messages now exist as Lua module shims. These shims are
byte-compatible placeholders, not feature-complete systems.

### Window module

The window module uses:

- client-to-server `0x5F`;
- server-to-client `0x5B`.

The module treats the first byte of `0x5F` as the current client
window/action discriminator and consumes only the payload bytes required by
that action. It then answers with structurally valid but empty `0x5B` windows:

- `0x00`: primary window;
- `0x01`: weekly-style window;
- `0x02`: shop-style window.

The weekly-style window keeps the current-client trailing reward field so the
following message starts at the correct opcode boundary.

This is enough for byte alignment and future feature work, but it does not
grant rewards, generate tasks, sell shop offers, or persist state.

### Side dialog module

The side dialog traffic uses `0xBA`.

The current module consumes the request shape and answers with an empty
structurally valid dialog/list. The real progression and fight behavior can be
added later without changing the message registration contract.

## Existing message corrections

Where the current client changed an existing message, the existing writer or
reader should be updated instead of adding a parallel implementation.

Examples in this update include:

- current graphical effect payloads that require the source byte;
- current character-specific side data;
- current skill wheel quest-bonus and gem-list payloads;
- current resource balances and 15.25 side messages;
- module dispatch for the new window and side-dialog messages.

## Review guidance

When reviewing this PR, distinguish these two categories:

- Byte compatibility: opcode, field order, field width, and runtime gating.
  These are in scope.
- Gameplay completeness: task generation, rewards, store offers, persistence,
  and balancing. These are intentionally deferred.

Do not replace a minimal shim with a full system unless the PR scope changes.
Future feature PRs should build on the existing byte contract and keep message
shapes stable.

## Validation checklist

For current-client validation:

- login with the current client profile;
- verify normal movement and basic gameplay after login;
- open the new window/dialog entry points if available and confirm the client
  does not debug;
- confirm older enabled profiles do not receive current-only bytes;
- inspect client logs or recorded bytes when a client debug occurs and verify
  the failing message boundary before changing bytes.

For source validation:

- keep new message behavior behind runtime feature flags;
- keep module registration in `data/modules/modules.xml`;
- keep new system placeholders in `data/modules/scripts/` unless core message
  plumbing is required;
- do not hardcode local client or repository paths in documentation.
