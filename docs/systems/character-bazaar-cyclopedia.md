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
uses a 12 percent commission. Active and processing auctions block login while
the integration is enabled. Processing auctions settle through scheduled server
save; review the external custody contract before enabling the feature.

## Raid markers

XML single/area spawns and Lua `Raid` encounters register successful live monster
placements. Shared marker positions are reference-counted. Creature removal
releases ownership, and login replays retained markers. Custom Lua spawn paths
must call `monster:setRaidMapMarker(position)` explicitly.

## Donations and discovery

Donations debit the character bank, accumulate the exact area's total and append
an audit row in one SQL transaction. Only committed donations update live bank
state. The scheduled server-save hook rotates the daily winner once per UTC day;
loading and restarts do not rotate, and losing donations are retained. Matching
spawn tiles use half their base interval, bounded by the existing minimum. The
base interval is never overwritten.

Discovery creates five separated points using bounded traversal of reachable
tiles inside exact subarea masks. Only the owning character's ordinary movement
earns progress. Teleports do not earn progress. Transitions persist before
effects, messages or snapshots expose them; hidden points stay off the wire.

The JSON catalogs contain area identities and horizontal tile runs. Re-export
them using `export_cyclopedia_donation_areas.py` and
`export_cyclopedia_discovery_areas.py`, passing the client directory and output
path. Exporters require only Python's standard library.

## Outstanding upstream compatibility

The donation and discovery implementations currently create dedicated SQL
tables. This conflicts with CONTRIBUTING.md's requirement to use KV rather than
introduce new tables. They are included as an explicit draft review blocker;
their transactional persistence must be adapted before this contribution can
claim compliance with that policy. The external Bazaar schema is also an
integration dependency that upstream maintainers must evaluate.

The local C++ audits use transactional database and map test doubles. They do
not prove MariaDB integration, client interoperability or gameplay. Full server
build/linking, a disposable database run, connected client testing and upstream
CI remain required before merge. No local server, database, configuration or
production executable is changed by running these audits.

From an MSVC developer shell with dependencies installed, run:

```powershell
# Optional when dependency headers are outside build/windows-release/vcpkg_installed:
$env:CANARY_AUDIT_INCLUDE = '<vcpkg-installed>/x64-windows-static-release/include'
python tools/canary_audit/test_cyclopedia_raid_markers.py
python tools/canary_audit/test_cyclopedia_donations.py
python tools/canary_audit/test_cyclopedia_discovery.py
```
