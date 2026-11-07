"""Read-only byte walkers for Cyclopedia donations.

Response widths come from the official 15.25 reader at 0x1405E16D8.
Request widths come from the current server handler; the client serializer
and a real request capture remain to be independently confirmed.
Unproven semantic fields deliberately retain raw names.
"""
import argparse
from pathlib import Path
import struct


def decode_response(data):
    if len(data) < 11 or data[:2] != b"\xdd\x09":
        raise ValueError("Expected donations response header (0xDD/9)")
    value = struct.unpack_from("<Q", data, 2)[0]
    count = data[10]
    if len(data) != 11 + count * 11:
        raise ValueError("Donation count/length mismatch or trailing bytes")
    records = []
    for i in range(count):
        area, flag, amount = struct.unpack_from("<HBQ", data, 11 + i*11)
        records.append({"area_id": area, "flag_raw": flag, "value_u64": amount})
    return {"global_u64": value, "areas": records}


def decode_request(data):
    if len(data) != 8 or data[:2] != b"\xdb\x01":
        raise ValueError("Expected server donation request layout (0xDB/action1), 8 bytes")
    area, amount = struct.unpack_from("<HI", data, 2)
    return {"area_id": area, "amount_u32": amount}


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("packet", type=Path)
    parser.add_argument("--request", action="store_true")
    args = parser.parse_args()
    try:
        print((decode_request if args.request else decode_response)(args.packet.read_bytes()))
    except (ValueError, OSError) as error:
        parser.exit(1, f"FAIL: {error}\n")
