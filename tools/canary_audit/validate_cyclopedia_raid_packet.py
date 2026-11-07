"""Walk 15.25 0xDD/2 raid-marker bytes; never sends a packet.

Reader: 0x1405E13AA position, 0x1405E1405 u8 change. Position uses the
same five-byte representation as subtype 0 (existing minimap markers).
Enum descriptors: RAID_CHANGE_ADD=0, RAID_CHANGE_REMOVE=1 in client.exe.
This checks wire alignment only, not live rendering or server lifecycle.
"""

import argparse
from pathlib import Path
import struct


def decode_packet(data: bytes) -> dict:
    if len(data) != 8:
        raise ValueError("Expected exactly 8 bytes: opcode, subtype, position, change")
    opcode, subtype, x, y, z, change = struct.unpack("<BBHHBB", data)
    if (opcode, subtype) != (0xDD, 2):
        raise ValueError("Expected Cyclopedia map active raid (0xDD/2)")
    if change not in (0, 1):
        raise ValueError("Unknown raid change value")
    return {"x": x, "y": y, "z": z, "change": "add" if change == 0 else "remove"}


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("packet", type=Path)
    args = parser.parse_args()
    try:
        print(decode_packet(args.packet.read_bytes()))
    except (OSError, ValueError) as error:
        parser.exit(1, f"FAIL: {error}\n")
