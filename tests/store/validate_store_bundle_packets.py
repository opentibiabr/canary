"""Independent byte walk of real Lua Store packets, based on the 15.25 reader.

Run the Lua description test with CANARY_STORE_BUNDLE_PACKET=<prefix>, then pass
that prefix here. No server/client sessions or database are accessed.
"""
from pathlib import Path
import struct
import sys


class Reader:
    def __init__(self, data):
        self.data, self.offset = data, 0

    def number(self, fmt):
        value, = struct.unpack_from("<" + fmt, self.data, self.offset)
        self.offset += struct.calcsize(fmt)
        return value

    def string(self):
        length = self.number("H")
        end = self.offset + length
        assert end <= len(self.data)
        value = self.data[self.offset:end].decode("ascii")
        self.offset = end
        return value

    def appearance(self):
        kind = self.number("B")
        assert kind in (1, 2, 3)
        look = self.number("H")
        if kind == 2:
            assert [self.number("B") for _ in range(4)] == [10, 20, 30, 40]
        return kind, look


# IDs independently established from the native assets and public component list.
EXPECTED = {
    70010: (1675, 1676, 1677, [44030]),
    70011: (1776, 1777, 1778, [48574, 48576]),
    70012: (1814, 1815, 1813, [50213]),
    70013: (1837, 1838, 1836, [50435]),
    70014: (1874, 1875, 1873, [51706]),
    70015: (1920, 1921, 1919, [52867]),
}


def walk(data, female=False, products=True):
    r = Reader(data)
    assert r.number("B") == 0xFC
    assert r.string() == "Bundles"
    assert r.number("I") == 0  # redirect
    assert r.number("B") == 0  # ordinary category, not home
    assert r.number("B") == 0 and r.number("H") == 0  # collections
    assert r.number("H") == 0  # no disabled reasons in this fixture
    assert r.number("H") == 6
    seen = set()
    first_outfit_colours = None
    for _ in range(6):
        assert r.string().endswith("Bundle")
        assert r.number("B") == 1
        offer_id = r.number("I")
        assert offer_id in EXPECTED and offer_id not in seen
        seen.add(offer_id)
        male, woman, mount, items = EXPECTED[offer_id]
        outfit = woman if female else male
        assert r.number("H") == 1 and r.number("I") == 1500
        assert r.number("B") == 1  # transferable currency
        assert r.number("B") == 0 and r.number("B") == 0  # disabled, highlight
        assert r.number("B") == 0  # static composed preview
        icon = r.string()
        assert icon.startswith("Bundle_") and icon.endswith("_1525.png")
        assert r.number("B") == 0  # no outfit-only try-on for a composed image
        assert r.number("H") == 0 and r.number("H") == 0 and r.number("I") == 0
        assert r.number("B") == 0  # configure
        count = r.number("H")
        assert count == (2 + len(items) if products else 0)
        expected = [(2, outfit), (1, mount)] + [(3, i) for i in items]
        for index in range(count):
            name = r.string()
            assert name
            if index == 0:
                assert name.startswith("Full ") and name.endswith(" Outfit")
                if first_outfit_colours is None:
                    first_outfit_colours = r.offset + 3
            assert r.appearance() == expected[index]
    assert seen == set(EXPECTED) and r.offset == len(data), "Packet was not fully consumed"
    return first_outfit_colours


prefix = sys.argv[1]
for name in ("male", "female", "otclient", "other-version"):
    data = Path(prefix + "-" + name + ".bin").read_bytes()
    offset = walk(data, female=name == "female", products=name in ("male", "female"))
    for bad in (data[:-1], data + b"\x00"):
        try:
            walk(bad, female=name == "female", products=name in ("male", "female"))
        except (AssertionError, struct.error, UnicodeDecodeError):
            pass
        else:
            raise AssertionError("Accepted truncated/trailing packet")
    if offset is not None:
        try:
            walk(data[:offset] + data[offset + 4:], female=name == "female")
        except (AssertionError, struct.error, UnicodeDecodeError):
            pass
        else:
            raise AssertionError("Accepted missing native outfit colours")
    print(f"PASS: complete actual {name} packet; counts, names, images, colours and rejection cases")

# Independently consume the actual furniture packet; reject item-zero previews.
if Path(prefix + "-house.bin").exists():
    expected = {int(row[0]): (int(row[1]), int(row[2])) for row in
                (line.split("\t") for line in Path(prefix + "-house.tsv").read_text().splitlines())}
    for case, title in [("house", "Furniture"), ("home", "Home")]:
        r = Reader(Path(prefix + "-" + case + ".bin").read_bytes())
        assert r.number("B") == 0xFC and r.string() == title
        assert r.number("I") == 0 and r.number("B") == 0
        assert r.number("B") == 0 and r.number("H") == 0
        assert r.number("H") == 0 and r.number("H") == 33
        seen = set()
        for _ in range(33):
            assert r.string() and r.number("B") == 1
            offer = r.number("I")
            item, price = expected[offer]
            assert offer not in seen
            seen.add(offer)
            assert r.number("H") == 1 and r.number("I") == price
            assert r.number("B") == 1 and r.number("B") == 0 and r.number("B") == 0
            assert r.number("B") == 3 and r.number("H") == item and item > 0
            assert r.number("B") == 0 and r.number("H") == 0 and r.number("H") == 0
            assert r.number("I") == 0 and r.number("B") == 0 and r.number("H") == 0
        if case == "home":
            assert r.number("B") == 0 and r.number("B") == 10
        assert seen == set(expected) and r.offset == len(r.data)
        print("PASS: independently consumed all 33 actual furniture previews; no zero/table IDs")
