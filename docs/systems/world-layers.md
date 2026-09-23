# World configuration format

World JSON in the datapack's `world/` directory is the source of configuration
for Canary and RME. The OTBM supplies terrain and base items. JSON supplies stable
identities, bindings, created content, attributes, relationships and behavior
parameters. RME edits these files through its normal map canvas, palette,
properties and history. There is no export step or OTBM format extension.

The Global datapack includes a migrated catalog at
`data-otservbr-global/world/otservbr.world.json`. Install its matching normal
`otservbr.otbm` alongside it. See [configuration and migration](world-migration.md)
for compatibility modes, customized installations and returning to legacy.

## Catalog and discovery

The current contract is `schemaVersion: 2`. Its schemas are
[`world-project-v2`](../../schemas/world-project-v2.schema.json),
[`world-layer-v2`](../../schemas/world-layer-v2.schema.json),
[`world-common-v2`](../../schemas/world-common-v2.schema.json),
[`world-behavior-v2`](../../schemas/world-behavior-v2.schema.json) and
[`world-migration-v2`](../../schemas/world-migration-v2.schema.json).
Unknown fields, duplicate JSON properties, invalid types and unsupported versions
are errors. Parsing does not silently discard unsupported configuration.

```json
{
  "schemaVersion": 2,
  "id": "example",
  "map": "example.otbm",
  "items": "../../data/items/items.xml",
  "layers": [{ "file": "quests/example.layer.json", "enabled": true }],
  "behaviorCatalog": ["behaviors/quest_gated_door.behavior.json"],
  "migrations": []
}
```

Resolve paths relative to the file declaring them, using forward slashes.
The catalog explicitly lists layers, behavior descriptors and migration records.
Directory discovery never activates an unlisted file. Backups, drafts and
publication journals are not active configuration.

With `worldProject = "auto"`, Canary resolves
`<dataPackDirectory>/world/<mapName>.world.json`. Explicit World/mixed mode requires
a valid catalog matching the configured map and item catalog. RME opens the OTBM
first, then looks for its sibling catalog or explicit association and parses the
World project in the background. A session/revision guard prevents a late result
from attaching to another map. Without a catalog, the map opens normally and the
Worlds palette offers catalog creation.

## Objects and selectors

Each layer has `id`, optional `name` and `objects`. Version 2 objects carry their
full stable identity, such as `example.lever`. Moving an object or its document
does not change its identity. Explicit renaming updates references. IDs begin
with a lowercase letter and contain lowercase letters, digits, dots, underscores
or hyphens, up to 256 characters. AID and UID are never object identities.

| Kind/source | Meaning |
| --- | --- |
| `anchor` | Reference position without a gameplay item |
| `item`, `map` | Bind and configure one existing base item |
| `item`, `create` | Create an externally owned item |
| `item`, `replace` | Consume one selected original and place its replacement |

```json
{
  "schemaVersion": 2,
  "id": "example",
  "objects": [
    {
      "id": "example.sign",
      "kind": "item",
      "source": {
        "mode": "map",
        "selector": {
          "position": { "x": 100, "y": 100, "z": 7 },
          "part": "item",
          "itemId": 2012
        }
      },
      "attributes": { "text": "Entrance to the library." }
    },
    {
      "id": "example.arrival",
      "kind": "anchor",
      "position": { "x": 110, "y": 110, "z": 7 }
    },
    {
      "id": "example.portal",
      "kind": "item",
      "source": {
        "mode": "create",
        "itemId": 1949,
        "count": 1,
        "placement": { "position": { "x": 102, "y": 100, "z": 7 } }
      },
      "lifecycle": "fixture",
      "components": [{
        "type": "teleport",
        "destination": {
          "object": "example.arrival",
          "offset": { "x": 0, "y": -1, "z": 0 }
        }
      }]
    }
  ]
}
```

Root selectors specify position, `part` (`ground` or `item`) and expected item ID.
Optional attributes constrain the original further. Container selectors identify
the parent by its World identity and match a child inside that container.
Selection requires exactly one match. Indistinguishable items require an explicit
`occurrence` with zero-based `index`, expected `count` and base-set `fingerprint`.
A changed precondition requires reassociation; no implicit first match is used.

Selection observes original OTBM content before external children are inserted.
Canary retains the authored item ID when its native map loader normalizes fields
such as fire into their persistent item types. This provenance is transient and
is not serialized into OTBM or copied to ordinary cloned items.

Creation specifies `itemId`, optional `count`/`subtype`, and a placement containing
either a position or a parent `container` identity and insertion `order`.
Parents resolve before children. Replacement has both a selector and creation
placement: moving the replacement does not move the original selection anchor.
Several compatible items may share a tile; two declarations cannot consume the
same original. Positions use X/Y 0..65535 and floors 0..15; the null position is
invalid. Offsets use signed X/Y and floor deltas and must resolve in range.

## Attributes and effective UIDs

Supported overrides are `aid`, `uid`, `text`, `description`, `name`, `article`,
`plural`, `writer`, `date`, and `custom`. Custom values are scalar booleans,
integers, finite numbers or strings; names under `__world.` are reserved for
runtime ownership metadata. Date is an unsigned 32-bit value.

A missing override inherits the base value. A present override applies its value;
`aid: 0` and `uid: 0` explicitly clear. Removing an override restores inheritance.
RME distinguishes inherited values from overrides and shows the destination file.

AID may repeat. A nonzero UID must be unique in the effective world, including
inherited attributes, replacements and nested container contents. Validation
accounts for consumed originals rather than reporting their replaced UID twice.
It also checks the server's live unique-item registry. The complete base-map UID
census includes cached items without materializing every tile.

## Relations, components and behaviors

A reference contains `object` and an optional spatial `offset`. Named relations
can hold one reference or a list. Descriptor relations declare target kind,
capabilities, cardinality and whether offsets are allowed. Moving the referenced
object updates the effective destination without changing the reference.

`teleport` is a native component with a destination reference. It requires a
compatible teleport item, valid arrival and an acyclic effective teleport chain.
These restrictions do not prohibit doors or general relation cycles. Containment
cycles and teleport arrival cycles are checked separately.

Behavior descriptors declare a versioned Lua implementation, events, parameters,
defaults, limits, relations and editor help. Instance bindings live on objects.
RME builds controls from descriptors, including typed lists and records. Canary
passes typed configuration copies and resolved references to the implementation.
See [World behaviors and Lua](world-behaviors.md) for APIs, events and deferred
work. An assigned World event consumes that instance's event even when denied;
other events retain their native or legacy dispatch.

The Global migration preserves Lua teleport rules through World behaviors when
those rules differ from native teleport semantics. The two Black Knight objects
use native components, retaining UIDs 38012/38013 and arrival offsets `(0,-7,0)`
and `(0,1,0)`. This example does not limit the supported configuration model.

## Lifecycle, containers and persistence

Map bindings normally keep `native` lifecycle. Explicit `fixture` bindings are
fixed. External items choose `fixture` or `refillOnStartup`.

| Policy | Runtime behavior |
| --- | --- |
| `native` | Keep native item movement and invalidate or update its World binding as needed |
| `fixture` | Keep one managed fixed instance; ordinary inventory transfer is denied |
| `refillOnStartup` | Reconcile collectible content after persistence loads |

For refill content, the runtime searches the declared destination for ownership
metadata: zero matches creates an item, one reuses it, and multiple matches are a
conflict. It does not delete duplicates automatically. Removing a collectible
from its source domain makes it an ordinary item and retires its World binding.
It is not refilled immediately; a later startup may replace the missing content.
Refill declarations cannot reserve an exclusive UID.

The runtime stores ownership metadata through existing item persistence, not a
parallel configuration database. Player-owned items keep ordinary persistence.
Movement, removal, transformation and stack operations update bindings and retire
stale generations. Deferred Lua work resolves an identity/generation/epoch token
before accessing an item.

House serialization projects underlying attributes into a clone instead of
mutating the live item during save. World overrides are not saved as inherited
base values that could reappear after their JSON override is removed. RME shows
initial configuration; live quest state and player persistence remain server
responsibilities.

## Server load and failure boundary

1. Determine the compatibility mode; load and validate declarations, descriptors
   and migration ownership before script registration.
2. Load scripts and register matching behavior implementations.
3. Read OTBM and capture original selections before auxiliary configuration and
   persisted content change the effective items.
4. Run allowed legacy startup and complete existing house operations.
5. Revalidate live targets, prepare creations and attribute snapshots, then apply
   the declarative plan and publish instance bindings before opening the server.

Preparation/validation errors abort startup. Application failures roll back
attributes, UIDs, created/replaced content and instance bindings. This boundary
does not promise rollback of arbitrary Lua/database effects. Declarations can be
queried before publication; live items are unavailable until they are bound.

Startup applies configuration once. Lua reload validates and rebinds compatible
implementations but does not reread World JSON. Invalid callbacks remain
unavailable, without permissive fallback. Custom map-region replacement is not a
supported live World reload mechanism.

## Editing and file changes

Open the normal OTBM in RME and use the Worlds palette, canvas and item properties.
Map bindings, external items, replacements, anchors, layers, attributes,
behaviors, relations and container content share the native undo timeline.
Moving a base item updates its OTBM position and selector together; moving an
external item changes JSON only. Replacement originals remain in the base OTBM.

Ctrl+S saves each dirty destination. JSON-only edits whose selectors already match
the persisted map skip OTBM serialization. When a World declaration depends on a
created, moved, retyped or reparented unsaved base item, RME stages and publishes
the OTBM and World files as one recoverable operation; an OTBM serialization
failure publishes no dependent JSON. Invalid configuration blocks normal
publication and can be preserved in a separate inactive draft. External JSON is
validated before replacing the scene; invalid syntax or missing files preserve
the last valid state and local work. Conflicts offer base/local/disk comparison,
a draft copy or confirmed reload. History tied to superseded document revisions
cannot overwrite external changes.

Catalog/layer publication uses exact revision guards, cooperative locks,
recoverable displaced versions and a pending marker. Canary rejects incomplete
publications. See [file publication and recovery](world-file-publication.md).

## Version 1 compatibility and validation

Version 1 catalogs and layers remain readable. They use layer-qualified local
object IDs, external teleport origins and the original restricted placement
rules. Opening alone does not rewrite them. Structural v2 authoring requires
explicit conversion, which preserves their fully qualified identities. Older
v1-only readers reject v2 instead of guessing at its fields.

The shared native contract, map validator, file service and schemas are maintained
in Canary's `src/world/` and RME's `source/world/`. Changes must keep their common
implementations and fixtures equivalent. The Python migrator calls the packaged
native [world-tool](../../tools/world_tool/README.md); it does not duplicate map
or contract validation in Python.

See [the implementation record](world-implementation.md) for executed checks and
outstanding acceptance. Native unit tests, a visual editor walkthrough and actual
gameplay/persistence tests are separate evidence.
