# Character Bazaar and Cyclopedia map integration

This contribution targets the upstream single-Game server and the inspected
official client build `15.25.0a00a0d67311e057aa8e659a84cdf51db9c08c03`.
Other clients do not receive the new experimental packets.

## Character Bazaar

Set `characterAuctionProbe = true` only with the compatible external MyAAC Bazaar
installed. The default is disabled. The server supplies eligibility, depot item
and character highlight catalogs; validation expires after two minutes and final
confirmation must match a single-use validated request. Private drafts use the
character KV scope `character-bazaar`, with current account ownership recorded.

Publication requires the external `myaac_charbazaar` and `myaac_charbazaar_bid`
schema, including `world_id`, `currency`, `commission_percent`, `creation_fee`
and `client_metadata`. The upstream integration uses world metadata value zero;
the upstream `players` table does not require a `world_id` column. Existing
website bidding, custody, cancellation and settlement state conventions remain
external dependencies. The website implementation is not part of this server PR.
Publication charges one transferable coin in the publication transaction and
uses a 12 percent commission. Active and processing auctions block login even when
new publication is disabled. Processing auctions settle through scheduled server
save. Set `characterAuctionCustodyAccount` to the external website's custody
account if the website transfers listed characters into a neutral account.
The default zero accepts only the original seller as the current holder.
Settlement rejects online characters and unexpected owners, checks commission
and credit bounds, and commits remainders, seller proceeds and ownership together.

## Raid markers

XML single/area spawns and Lua `Raid` encounters register successful live monster
placements. Shared marker positions are reference-counted. Creature removal
releases ownership, and login replays retained markers. Custom Lua spawn paths
must call `monster:setRaidMapMarker(position)` explicitly.

## Donations and discovery

Donations debit the character bank, accumulate the exact area's total and append
a timestamped audit entry in one SQL transaction. Only committed donations update live bank
state. The scheduled server-save hook rotates the daily winner once per UTC day;
loading and restarts do not rotate, and losing donations are retained.
Server-save processing retries failures twice at five-second intervals before
continuing the configured close/shutdown; committed work is not repeated. Matching
spawn tiles use half their base interval, bounded by the existing minimum. The
base interval is never overwritten.

Discovery creates five separated points using bounded traversal of reachable
tiles inside exact subarea masks. Only the owning character's ordinary movement
earns progress. Teleports do not earn progress. Transitions persist before
effects, messages or snapshots expose them; hidden points stay off the wire.

The JSON catalogs contain area identities and exact horizontal tile runs for the
supported client version, rather than approximate bounding rectangles.

## Persistence and migration

Donations, their audit entries and discovery snapshots use the existing
`kv_store` and the standard protobuf `ValueWrapper.str_value` codec. No new
tables are created. Migration 60 is registered in both supported data packs;
its implementation is shared in `data/migrations/cyclopedia_kv.lua`.

The migration imports world-zero legacy donation totals, active boosts, the
saved cycle, donation logs and per-character discovery points in one transaction.
It preserves all source tables, rejects conflicting existing KV values and
invalid input (including unknown discovery areas, noncanonical numbers and
points outside exact masks), and does not overwrite live progress on replay. Nonzero-world
legacy databases must stay with their matching multiworld server: this upstream
single-Game migration explicitly refuses those imports. Fresh `schema.sql`
installs seed the same empty snapshots and migration marker at version 60.

Back up the database before upgrading. A migration error leaves the completion
marker absent and the features unavailable; fix the reported input or database
failure before retrying startup. Do not delete source tables until the operator
has verified the imported state and their backup/rollback plan.

The `cyclopedia.atomic.*` keyspace is exclusively owned by `CyclopediaStorage`.
It bypasses the global KV write-back cache so a general save cannot overwrite
a newer committed snapshot. Row locks serialize donations with cycle rotation;
discovery additionally compares its previously loaded snapshot before writing.
Character/account ownership is checked under the same transaction.

## Validation

The Windows Release server was built and linked with the pinned dependency
baseline. Local C++ fixtures exercised live marker ownership, 28 donation checks,
29 discovery checks and 16 Bazaar settlement checks. The actual migration ran
under LuaJIT 2.1 against a disposable MariaDB database, covering fresh state,
BIGINT precision, active-cycle preservation, replay, conflicting imports,
rollback, invalid points and world rejection. These local harnesses are not
included in this contribution.

Connected client gameplay and end-to-end external website operation still need
operator validation. On a disposable copy, verify an eligible Bazaar publication
and scheduled settlement; overlapping raid monsters and the final marker
removal; a donation, rollback and restart; and discovery with ordinary movement,
teleports and relog. Confirm bank balances, owners and snapshots before using
the features on a live server. Automated fixtures do not replace these checks.
