# Client 15.25 compatibility update

This document describes the scope of the 15.25 client compatibility update for
Canary. The Task Board packet contract is now backed by a modular Lua system;
other compatibility-only messages remain byte-contract work unless their own
system documentation says otherwise.

## Intent

The goal is to keep Canary aligned with the current client message contract so
sessions can login and keep running without client debugs caused by missing or
misaligned bytes.

This PR should be reviewed as byte compatibility support:

- update the current runtime profile to advertise confirmed 15.25 message
  capabilities;
- send and parse the bytes expected by the current client;
- keep new message shapes behind runtime feature flags;
- keep the Task Board implementation modular and isolated from the protocol
  dispatcher.

## Non-goals

This PR intentionally does not implement the full gameplay systems behind the
new messages, except for the Task Board module described below.

The following remain out of scope unless a later change adds them explicitly:

- complete gameplay behavior for the new vocation/skill side payloads beyond
  byte compatibility;
- new monetization/store offers outside the Task Board module;
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

## Task Board module

The Task Board implementation lives in
`data/modules/scripts/taskboard/`. Its component boundaries, persistent KV
schema, behavior, adapter boundary, and validation commands are documented in
[`taskboard-module.md`](taskboard-module.md).

### Window module

The window module uses:

- client-to-server `0x5F`;
- server-to-client `0x5B`.

The module treats the first byte of `0x5F` as the current client
window/action discriminator and consumes only the payload bytes required by
that action. It then answers with the matching `0x5B` window containing the
player's generated and persisted state:

- `0x00`: primary window;
- `0x01`: weekly-style window;
- `0x02`: shop-style window.

The weekly-style window keeps the current-client trailing reward field so the
following message starts at the correct opcode boundary. The optional
Soulseals tail is selected by the conservative client-version gate documented
in the module contract.

The module generates bounty and weekly tasks from loaded monster types,
persists progress, awards rewards, processes item delivery, exposes the shop,
and integrates kill/talisman effects through Lua callbacks.

### Side dialog module

The side dialog traffic uses `0xBA`.

The Task Board module consumes the request shape and sends the configured
Soulpit race list. Soulpit selection is authorized for a short window and
requires a server-provided `SoulPit.startSoloFight` adapter; without that
adapter the request is rejected without deducting Soulseals. This keeps map and
arena ownership outside the generic packet module.

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

When reviewing this change, distinguish these two categories:

- Byte compatibility: opcode, field order, field width, and runtime gating.
  These are in scope.
- Gameplay adapters: map-specific Soulpit entry points and any server-owned
  content catalog extensions. These are explicit integration points.

Keep message shapes stable when extending the module. Add server-specific
content through its configuration and adapters rather than copying a second
implementation of the protocol writers.

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

- keep new message behavior behind the existing runtime profile dispatch;
- keep module registration in `data/modules/modules.xml`;
- keep Task Board behavior in `data/modules/scripts/taskboard/` and its narrow
  event callbacks unless core message plumbing is required;
- do not hardcode local client or repository paths in documentation.
