"""Export exact official-client area masks as bounded horizontal tile runs.

Reads assets only. Requires the inspected map schema; no approximate rectangles.
"""
import argparse
import hashlib
import json
import lzma
from pathlib import Path
import struct

from cyclopedia_asset_wire import protobuf_fields


def export(client, output):
    assets = client / "assets"
    source = next(assets.glob("map-*.dat"))
    fields = protobuf_fields(source.read_bytes())
    areas = {}
    parent = {}
    for number, wire, raw in fields:
        if number != 1 or wire != 2:
            continue
        fs = protobuf_fields(raw)
        v = {n: value for n, w, value in fs}
        if v.get(3) == 1:
            area = v[1]
            areas[area] = {"id": area, "name": v[2].decode(), "reject": bool(v.get(6, 0)), "runs": []}
            for n, w, value in fs:
                if n == 4:
                    parent[value] = area
    files = 0
    for number, wire, raw in fields:
        if number != 3 or wire != 2:
            continue
        v = {n: value for n, w, value in protobuf_fields(raw)}
        if v.get(1) != 0 or v.get(6) not in parent:
            continue
        area = areas[parent[v[6]]]
        if area["reject"]:
            continue
        coordinate = {n: value for n, w, value in protobuf_fields(v[2])}
        compressed = (assets / v[3].decode()).read_bytes()
        # Tibia wrapper: LZMA1 properties at byte32, stream starts at45.
        if compressed[32:37] != bytes.fromhex("5d00000002"):
            raise ValueError("Unexpected bitmap compression properties")
        bitmap = lzma.decompress(compressed[45:], format=lzma.FORMAT_RAW,
                                 filters=[{"id": lzma.FILTER_LZMA1, "dict_size": 1 << 25, "lc": 3, "lp": 0, "pb": 2}])
        if bitmap[:2] != b"BM":
            raise ValueError("Not a bitmap")
        offset = struct.unpack_from("<I", bitmap, 10)[0]
        width, height, planes, bits = struct.unpack_from("<iiHH", bitmap, 18)
        if width != v[4] or abs(height) != v[5] or planes != 1 or bits != 32:
            raise ValueError("Bitmap/schema dimensions disagree")
        if len(bitmap) != offset + width * abs(height) * 4:
            raise ValueError("Incomplete mask")
        for row in range(abs(height)):
            stored = abs(height)-row-1 if height > 0 else row
            pixels = struct.unpack_from("<" + "I" * width, bitmap, offset + stored*width*4)
            start = None
            for x in range(width + 1):
                value = pixels[x] if x < width else 0
                if value not in (0, 0xFFFFFFFF):
                    raise ValueError("Unexpected mask colour")
                if value and start is None:
                    start = x
                if not value and start is not None:
                    area["runs"].append([coordinate[3], coordinate[2]+row, coordinate[1]+start, coordinate[1]+x-1])
                    start = None
        files += 1
    for area in areas.values():
        area["runs"] = [list(r) for r in sorted(set(tuple(r) for r in area["runs"]))]
    result = {"source_sha256": hashlib.sha256(source.read_bytes()).hexdigest(), "areas": list(areas.values())}
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(json.dumps(result, separators=(",", ":"), ensure_ascii=False), encoding="utf-8")
    print(f"PASS: {files} exact subarea masks, {sum(len(a['runs']) for a in areas.values())} tile runs, {output.stat().st_size} bytes")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("client", type=Path)
    parser.add_argument("output", type=Path)
    args = parser.parse_args()
    export(args.client, args.output)
