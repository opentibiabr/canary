# Store bundles for client 15.25

The top-level Bundles category contains the following 1,500 TC offers. Each
unlocks the full outfit (both addons, both sexes) and mount for the purchasing
character and delivers owner-bound decoration kits into that character's Store
Inbox. The initial preview uses a composed 64px PNG showing the outfit, mount
and decoration together, through the existing static-image display type.
The selected offer retains its individual native product images and names.
Descriptions use ASCII HTML markers to avoid UTF-8 bullet display
errors in the native client.

Composite icons are tracked under `data/images/store/64/`. Deploy them to the
HTTP base configured by `coinImagesURL`; see `data/images/store/README.md`.
The local HTTP verification returned byte-identical PNGs for all six bundles.
Selecting a bundle displays its contents, and the static composite does not show
an outfit-only Try On action. Native rendering still requires a live client check.

Descriptions now separate the full outfit, mount and each decoration, with
their appropriate character/house/box/inbox/use markers. Burning Ash uses the
user-provided copy, including its 360 TC saving and italic narrative. Savings
against published standalone prices are Sweet Honey 380, Field Surgeon 420,
Martial Artist 340, Shadow Vengeance 360 and Burning Ash 360 TC. Rotten Blood
has exclusive components, so no unsupported standalone saving is advertised.

## Native package contents

The existing Store offer products list is now populated for native 15.25 clients
(modern client OS values 4/5/6). Each row has its component name and native
appearance, giving the client the data for its package contents section. Outfit
rows select the character's sex and colours; mount rows use client look types;
decoration rows use their unwrapped item IDs. Sickbed is one product with two
physical kits, while Sweet Honey lists both decorations separately. Unsupported
versions and OTClient retain a zero product count, since the inspected local
OTClient reader discards products with a fixed layout that omits outfit colours.

Read-only inspection used the installed 15.25 `bin/client.exe` with SHA-256
`c4a26ad3ca5afb8ec1775533b86865a5bccfdc83a535a9e6dafc5d3af9d8962b`.
In the offer decoder `0x1405E5DC0`, the product count is read as u16 at
`0x1405E63DD`, the product name as a string at `0x1405E640D`, and each product's
appearance through decoder vtable slot `0xC0` at `0x1405E64A7`. That slot points
to `0x1405D3890`: it reads a u8 display kind; kind 1 reads a u16 creature look,
kind 3 reads a u16 item ID, and kind 2 reads a u16 outfit look plus four u8
colours. Consequently the local OTClient's string/u8/u16-only discard loop is
not a sufficient interoperability specification for native outfit products.

`tests/lua/test_store_bundle_descriptions.lua` exercises the actual full category
sender and all six description packets. Set `CANARY_STORE_BUNDLE_PACKET` to a
temporary filename prefix to export male/female native and fallback packets;
then run `tests/store/validate_store_bundle_packets.py <prefix>`. Its
independent byte walker consumes the entire emitted packets, verifies fixed
component IDs, count/quantity/name/colour fields and rejects truncation, trailing
bytes and a synthetic missing-colour packet. No captured failed client packet
was available. Native rendering of the package list still needs a live check.

| Offer | Bundle | Outfit | Mount (server ID / client look) | Decoration kit targets |
| --- | --- | --- | --- | --- |
| 70010 | Rotten Blood | Darklight Evoker 1675/1676 | Darkfire Devourer 216/1677 | Mask of the Defiler 44030 |
| 70011 | Sweet Honey | Beekeeper 1776/1777 | Bumblebee 231/1778 | Candy Chest 48574; Beehive 48576 |
| 70012 | Field Surgeon | Field Surgeon 1814/1815 | Pallbearer 237/1813 | Empty Sickbed parts 50213/50214 |
| 70013 | Martial Artist | Martial Artist 1837/1838 | Satin Moth 238/1836 | Wooden Dummy 50435 |
| 70014 | Shadow Vengeance | Bat Knight 1874/1875 | Battle Werewolf 239/1873 | Effigy of Winged Vengeance 51706 |
| 70015 | Burning Ash | Phoenix Evoker 1920/1921 | Flame Bear 240/1919 | Barebone Grill 52867 |

Server mount IDs are local persistence IDs. They are not client look types.
Sickbed uses two kits and the twelve-state bed model. Candy Chest has 18 slots;
Wooden Dummy is decorative and does not grant exercise training. New furniture
states retain wrapping support. Mask, effigy and grill have cosmetic use cycles.

## Sources and version cutoff

The [public bundle index](https://www.tibiawiki.com.br/wiki/Bundles) lists the
first five bundles. Their individual pages document contents, 1,500 TC price
and versions: [Rotten Blood](https://www.tibiawiki.com.br/wiki/Rotten_Blood_Bundle),
[Sweet Honey](https://www.tibiawiki.com.br/wiki/Sweet_Honey_Bundle),
[Field Surgeon](https://www.tibiawiki.com.br/wiki/Field_Surgeon_Bundle),
[Martial Artist](https://www.tibiawiki.com.br/wiki/Martial_Artist_Bundle), and
[Shadow Vengeance](https://www.tibiawiki.com.br/wiki/Shadow_Vengeance_Bundle).
The index omits Burning Ash, announced on 19 December 2025 in
[official news 8569](https://www.tibia.com/news/?subtopic=newsarchive&id=8569),
also available through the [news mirror](https://www.tibiaxplorer.com/tibia_news/169).
[TibiaWiki.dev](https://tibiawiki.dev/api/outfits/Phoenix%20Evoker%20Outfits)
identifies Phoenix Evoker as 15.20.6bd207; its Flame Bear entry records 870 TC and
360 TC savings for the bundle. Together with the 120 TC Barebone Grill this is
1,500 TC. Names, outfit look types and mount look types were cross-checked through
the TibiaWiki.dev outfit/mount/item endpoints and both local appearance files.
The native 15.25 cache contains `Product_December2025_Bundle.png` and
`Category_Bundles.png`. The Broken Moon bundle belongs to 15.30 and is excluded.

## Purchase behavior and validation

The purchase path rechecks availability and funds, prepares every kit, and only
then verifies cosmetic unlocks before calling the existing Store payment method
once. Any delivery, unlock or payment failure removes the prepared kits and
restores both sexes' exact prior outfit/addon ownership and any existing mount. No delayed
callbacks or shared world-owned mutable state are introduced. Existing cosmetic
components are retained at full bundle price; owning both the full outfit and
mount, or an earlier successful bundle purchase, prevents a duplicate purchase.
The purchase marker belongs to the purchasing character.

Run with LuaJIT and Python 3 from the repository root. The asset audit additionally
requires the installed native 15.25 appearance files:

```text
luajit tests/lua/test_store_bundles.lua
python tests/store/validate_store_bundles.py
```

The Lua flow test runs the real parser and purchase module with mocked engine
objects. It covers all six bundles, both sexes, single charging, duplicates,
partial ownership, failed second-kit delivery, failed payment, insufficient
funds and unavailable components. The read-only asset audit validates every
configured ID against XML plus server and installed client appearances.
These are local checks, not live gameplay or MariaDB crash-recovery proof.
Payment and player persistence retain the Store's existing service guarantees.

The raw-ownership flags on `Player:hasOutfit(lookType, addon, ownedOnly)` and
`Player:hasMount(mountIdOrMountName, ownedOnly)` require
an updated server binary. Its default behavior remains the existing wearability
check; `ownedOnly=true` bypasses sex/premium/access restrictions to read actual
ownership, including the opposite-sex outfit, for safe rollback.

Apply the rebuilt binary, updated scripts and appearance
XML registries through a controlled server restart before testing purchases,
unwrapping in an owned house, Sickbed sleep/wake, decoration state changes and
persistence after relog in both worlds. No live restart or purchase was executed
as part of this change.

## PR review regressions

The category and Home senders use the first item of a furniture set only for its
preview; the original four-item list remains the purchase source. Both real
packets are independently decoded by the preview tests.

`tests/store/test_store_icon_install.py` covers a fresh offline installation of
all 983 icons, mixed repository/archive precedence and rejected path/drive names.
The destination containment guard also rejects escaping child symlinks; creating
such a symlink was unavailable on the Windows validation host.
`tests/store/test_outfit_ownership_binding.py` compiles the actual hasOutfit
binding against LuaJIT with controlled player state, checking wearability defaults,
opposite-sex ownership, base-only outfits, addon masks and access-group behavior.
Bundle flow tests inject unlock failures before mutation, after mutation and
silent no-ops, then verify exact restoration without payment or purchase markers.

The duplicate check and rollback snapshots use raw ownership for both outfits and
mounts. Administrative access must not count as purchasing either component.
The Python image tools now require `tools/store/requirements.txt`; shared PNG
validation checks chunks/CRCs, a complete IEND trailer and actual pixel decoding.
Installer regressions cover signature-only files, dimension-only/truncated
headers, truncated IEND, invalid CRC and invalid compressed pixels with valid CRC.
Both installers reject these before writing even a valid prepared companion.
