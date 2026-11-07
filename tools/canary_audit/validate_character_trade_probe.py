"""Decode a diagnostic 0x80/0 packet using the inspected official 15.25 reader.

This checks wire alignment, not compatibility with the live client or auction rules.
The two u32 reads are at client.exe VAs 0x1405EB0FE and 0x1405EB11A;
they are followed by u16 at 0x1405EB139 and u8 at 0x1405EB150.
"""

import argparse
from pathlib import Path
import struct


def decode_probe(data: bytes, *, navigation_only: bool = False, eligibility: bool = False) -> list[tuple[str, int]]:
    position = 0

    def read(kind: str) -> int:
        nonlocal position
        width = struct.calcsize("<" + kind)
        if position + width > len(data):
            raise ValueError(f"Incomplete {kind} at offset {position}")
        value = struct.unpack_from("<" + kind, data, position)[0]
        position += width
        return value

    def text() -> str:
        nonlocal position
        size = read("H")
        if position + size > len(data):
            raise ValueError(f"Incomplete string at offset {position}")
        value = data[position:position + size].decode("utf-8")
        position += size
        return value

    if read("B") != 0x80 or read("B") != 0:
        raise ValueError("Expected diagnostic opcode 0x80, subtype 0")
    text()  # Character name.
    read("H")  # Level.
    read("B")  # Packed vocation data.
    look_type = read("H")
    if look_type:
        for _ in range(5):
            read("B")  # Four colors plus addons; no mount.
    else:
        read("H")  # Item look.
    read("B")
    read("I")
    read("I")  # Exactly TWO u32 fields, not three.
    read("H")
    count = read("B")
    conditions = []
    for _ in range(count):
        message, flag = text(), read("B")
        if flag not in (0, 1):
            raise ValueError("Invalid diagnostic condition flag")
        conditions.append((message, flag))
    if position != len(data):
        raise ValueError(f"Trailing bytes: consumed {position}/{len(data)}; next opcode=0x{data[position]:02X}")
    if eligibility:
        if not 12 <= count <= 14:
            raise ValueError("Expected 12 eligibility rows plus optional database/draft notices")
    else:
        expected_flags = [1, 1] if navigation_only else [1, 0]
        if count != 2 or [flag for _, flag in conditions] != expected_flags:
            raise ValueError(f"Expected two diagnostic conditions with flags {expected_flags}")
    return conditions


def decode_rejection(data: bytes, *, approval: bool = False) -> str:
    """Subtype 4: u16 creation fee, u8 error count, then strings.

    The client summary builder at 0x140310511 suppresses fee=0 and the
    loop at 0x140310550 sets hasConfirmationError for each supplied string.
    """
    if approval:
        if data != bytes((0x80, 4, 1, 0, 0)):
            raise ValueError("Expected creation fee 1 and no errors: 80 04 01 00 00")
        return ""
    if len(data) < 7 or data[:5] != bytes((0x80, 4, 1, 0, 1)):
        raise ValueError("Expected creation fee 1 and exactly one error")
    size = struct.unpack_from("<H", data, 5)[0]
    if len(data) != 7 + size:
        raise ValueError("Incomplete rejection string or trailing bytes")
    return data[7:].decode("utf-8")


def decode_catalog(data: bytes, tiered_ids: set[int]) -> list:
    """Read subtypes 1/2/3 using the inspected item/textual catalog loops."""
    position = 2

    def read(kind):
        nonlocal position
        width = struct.calcsize("<" + kind)
        if position + width > len(data):
            raise ValueError("Incomplete catalog field")
        value = struct.unpack_from("<" + kind, data, position)[0]
        position += width
        return value

    def text():
        nonlocal position
        size = read("H")
        if position + size > len(data):
            raise ValueError("Incomplete catalog string")
        value = data[position:position + size].decode("utf-8")
        position += size
        return value

    if len(data) < 3 or data[0] != 0x80 or data[1] not in (1, 2, 3):
        raise ValueError("Expected opcode 0x80, catalog subtype 1/2/3")
    result = []
    if data[1] in (1, 2):
        for _ in range(read("H")):
            item_id = read("H")
            tier = read("B") if item_id in tiered_ids else 0
            result.append((item_id, tier, read("I")))
    else:
        for _ in range(read("B")):
            category, label = read("B"), text()
            entries = [(read("H"), text()) for _ in range(read("H"))]
            result.append((category, label, entries))
    if position != len(data):
        raise ValueError(f"Trailing catalog bytes: {position}/{len(data)}")
    return result


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("packet", type=Path, help="Decoded application packet, including opcode")
    parser.add_argument("--navigation-only", action="store_true", help="Validate v3 (both conditions fulfilled)")
    parser.add_argument("--eligibility", action="store_true", help="Validate current eligibility conditions")
    parser.add_argument("--rejection", action="store_true", help="Validate v4 subtype-4 diagnostic rejection")
    parser.add_argument("--approval", action="store_true", help="Validate creation fee 1 with no confirmation errors (v15)")
    parser.add_argument("--simulation-approval", action="store_true", help="Validate v10 status-0 response enabling Confirm for simulation only")
    parser.add_argument("--catalog", action="store_true", help="Validate item/text catalog")
    parser.add_argument("--tiered-id", type=int, action="append", default=[], help="Item ID with optional tier byte (repeat as needed)")
    args = parser.parse_args()
    try:
        packet = args.packet.read_bytes()
        if args.simulation_approval:
            if packet != bytes((0x80, 4, 0, 0, 0)):
                raise ValueError("Expected exactly 80 04 00 00 00")
            print("PASS: complete simulation approval packet")
            raise SystemExit(0)
        if args.catalog:
            entries = decode_catalog(packet, set(args.tiered_id))
            print(f"PASS: complete catalog packet; entries={len(entries)}")
            raise SystemExit(0)
        if args.rejection or args.approval:
            decode_rejection(packet, approval=args.approval)
            print("PASS: complete diagnostic status packet")
            raise SystemExit(0)
        conditions = decode_probe(packet, navigation_only=args.navigation_only, eligibility=args.eligibility)
    except (ValueError, OSError) as error:
        parser.exit(1, f"FAIL: {error}\n")
    print(f"PASS: complete diagnostic packet; conditions={len(conditions)}")
