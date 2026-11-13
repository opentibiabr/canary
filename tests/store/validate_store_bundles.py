"""Read-only verification of 15.25 bundle IDs against XML and native assets."""
from pathlib import Path
import re
import struct
import xml.etree.ElementTree as ET

ROOT = Path(__file__).resolve().parents[2]


def fields(data):
    offset = 0

    def varint():
        nonlocal offset
        result = 0
        for shift in range(0, 70, 7):
            value = data[offset]
            offset += 1
            result |= (value & 127) << shift
            if value < 128:
                return result
        raise ValueError("Unbounded protobuf varint")

    while offset < len(data):
        tag = varint()
        number, wire = tag >> 3, tag & 7
        if wire == 0:
            value = varint()
        elif wire == 2:
            size = varint()
            value = data[offset:offset + size]
            assert len(value) == size
            offset += size
        elif wire in (1, 5):
            size = 8 if wire == 1 else 4
            value = data[offset:offset + size]
            assert len(value) == size
            offset += size
        else:
            raise ValueError(f"Unsupported protobuf wire type {wire}")
        yield number, value


def appearances(path):
    result = {1: {}, 2: {}}
    for category, raw in fields(path.read_bytes()):
        if category in result:
            entry = dict(fields(raw))
            assert entry[1] not in result[category]
            result[category][entry[1]] = entry
    return result


catalog = (ROOT / "data/modules/scripts/gamestore/catalog/bundles.lua").read_text(encoding="utf-8")
pattern = r'\{ (7001[0-5]), "([^"]+)", "([^"]+)", (\d+), (\d+), (\d+), \{ ([\d, ]+) \}'
entries = re.findall(pattern, catalog)
assert len(entries) == 6
assert '"bundles"' in (ROOT / "data/modules/scripts/gamestore/catalog/init.lua").read_text()
assert 'price = 1500' in catalog
assert 'OFFER_TYPE_BUNDLE' in catalog
icons = re.findall(r'"(Bundle_[A-Za-z_]+_1525\.png)"', catalog)
assert len(icons) == 6 and len(set(icons)) == 6
for filename in icons:
    data = (ROOT / "data/images/store/64" / filename).read_bytes()
    assert data[:8] == b"\x89PNG\r\n\x1a\n"
    assert struct.unpack_from(">II", data, 16) == (64, 64)
print("PASS: all six composed preview icons exist and are valid 64x64 PNGs")

items = ET.parse(ROOT / "data/items/items.xml").getroot()
mounts = ET.parse(ROOT / "data/XML/mounts.xml").getroot()
outfits = ET.parse(ROOT / "data/XML/outfits.xml").getroot()
native = appearances(ROOT / "data/items/appearances.dat")
client_files = list((ROOT.parent / "tibia-client-15.25.0a00a0/assets").glob("appearances-*.dat"))
assert len(client_files) == 1, "Expected the installed 15.25 client assets"
client = appearances(client_files[0])

for offer, bundle, outfit_name, male, female, mount_id, decoration_ids in entries:
    for sex, look in [("1", male), ("0", female)]:
        definitions = [o for o in outfits if o.get("type") == sex and o.get("looktype") == look]
        assert len(definitions) == 1 and definitions[0].get("name") == outfit_name
        assert definitions[0].get("unlocked") == "no" and definitions[0].get("from") == "store"
        assert int(look) in native[2] and int(look) in client[2]
    definition = [m for m in mounts if m.get("id") == mount_id]
    assert len(definition) == 1
    mount_look = int(definition[0].get("clientid"))
    assert mount_look in native[2] and mount_look in client[2]
    for item_id in map(int, decoration_ids.split(",")):
        definitions = [i for i in items if i.get("id") == str(item_id)]
        assert len(definitions) == 1 and definitions[0].get("name")
        assert item_id in native[1] and item_id in client[1]
        name = client[1][item_id].get(4, b"").decode("utf-8")
        assert definitions[0].get("name") == name
        attrs = {a.get("key").lower(): a.get("value") for a in definitions[0]}
        assert attrs.get("wrapableto") == "23398"
    print(f"PASS: {bundle}: both outfit sexes, mount and kits exist in server and client assets")

# Sickbed must start empty and preserve a complete pair through all states.
for item_id in range(50205, 50217):
    definition = next(i for i in items if i.get("id") == str(item_id))
    attrs = {a.get("key").lower(): a.get("value") for a in definition}
    assert attrs["type"] == "bed"
    partner = int(attrs["bedpartof"])
    assert 50205 <= partner <= 50216 and partner != item_id
    for key in ("rotateto", "maletransformto", "femaletransformto"):
        if key in attrs:
            assert 50205 <= int(attrs[key]) <= 50216
assert "50213, 50214" in catalog
print("PASS: Sickbed empty parts, partners, rotations and sleeper transforms are bounded")
