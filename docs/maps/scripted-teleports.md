# Script-controlled teleport admission

## Contract

A quest-gated portal must have one owner for both admission and destination.
Do not combine an automatic OTBM destination with an access script that tries
to undo the teleport after checking permission.

The engine invokes the native teleport before the tile's movement scripts:

1. The creature enters the portal tile.
2. The native destination, if present, moves the creature immediately.
3. The StepIn callback checks the quest and may request a return teleport.

That last request can fail, including when the global teleport guard rejects
repeated calls. Returning false from StepIn does not undo an earlier native
teleport. Ignoring this ordering lets denied creatures remain inside.

## Startup ownership

Use an explicit entry in
[TeleportAction](../../data-otservbr-global/startup/tables/teleport.lua):

~~~lua
[23103] = {
    scriptedTeleport = true,
    itemPos = {
        { x = 32208, y = 32033, z = 13 },
    },
},
~~~

This mode selects the actual teleport item by type, including portals with
different appearance IDs. It does not use the legacy `itemId = false` policy,
which assigns an action to the ground and other items on the tile.

The [startup loader](../../data-otservbr-global/startup/others/functions.lua):

- Clears the automatic destination to `(0,0,0)`, which the engine treats as
  having no native destination.
- Removes this same Action ID from the ground and other items, preserving
  unrelated Action IDs.
- Registers the Action ID on the teleport alone.
- Reports a missing teleport instead of attaching the event to another item.

Reapplying this configuration is idempotent. Only explicitly marked entries
use it; ordinary native portals and other legacy action registrations retain
their existing behavior.

Apply the configuration after loading the corresponding map and before
allowing players to enter it. Replacing one of these portal tiles with a later
map load also requires reapplying its configuration. Deploy startup-table
changes with a server restart; reloading only the movement script is not enough.

## Quest callback

The [Dream Courts callback](../../data-otservbr-global/scripts/quests/the_dream_courts_quest/movements_acessTeleports.lua)
selects one destination after evaluating permission, boss count and the current
boss cooldown. A denied entry selects the previous position. Check the
`teleportTo` result before reporting success or emitting a success effect.

If a return is rejected, the creature can remain on the outside portal tile,
but must never have visited the protected room. A return teleport is feedback,
not the security boundary. Repeated attempts must not grant storage values or
consume multiple teleport requests through duplicate item callbacks.

Keep the native recursion and rate-limit guards unchanged. Raising their limits,
exempting all rollback requests, or changing client walking cannot fix admission
that already occurred before the permission check.

## Regression coverage

From the repository root:

~~~sh
luajit tests/lua/test_dream_courts_teleport_access.lua
~~~

The suite loads the actual storage definitions, startup tables, loader and quest
script. Its engine doubles preserve native-before-StepIn ordering and injected
teleport failures. It covers:

- A negative control reproducing the sixth-entry bypass with an automatic
  destination, duplicate callbacks and a ten-call budget.
- One hundred denied retries, including failed returns, without entering the room.
- All five Dream Courts gates, both teleport appearance IDs, seven weekdays,
  boss-count thresholds and cooldown boundaries.
- Correct `PlagueRootTimer` storage lookup on Saturday.
- Startup reapplication, duplicate cleanup, unrelated actions, ordinary native
  portals, non-player creatures and failed authorized teleports.

These are Lua behavior tests, not a native server or networking integration test.
For a live retest, restart the updated server and test both eligible and
ineligible characters at `(32208,32033,13)`. Repeat denied entries quickly:
there must be no intermediate appearance inside `(32208,32026,13)`, even when a
return teleport is rejected. Verify the Nightmare Beast and Haunted House gates,
then check an ordinary portal and normal walking.
