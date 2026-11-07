"""Walk 15.25 discovery packets from the independently inspected map reader.

No networking. Unknown semantics retain raw field names. Area percentage is a
wire integer divided by 100.0 by the client, not an IEEE float on the wire.
"""
import argparse
from pathlib import Path
import struct


def decode_packet(data):
    pos = 0
    def read(format):
        nonlocal pos
        width = struct.calcsize('<' + format)
        if pos + width > len(data):
            raise ValueError('Truncated discovery field')
        values = struct.unpack_from('<' + format, data, pos)
        pos += width
        return values[0] if len(values) == 1 else values
    if read('B') != 0xDD:
        raise ValueError('Expected Cyclopedia map opcode')
    subtype = read('B')
    if subtype == 1:
        areas = []
        for _ in range(read('H')):
            area, grade, percent = read('HBB')
            areas.append({'area':area, 'grade_raw':grade, 'percent_raw':percent})
        groups = [[read('H') for _ in range(read('H'))] for _ in range(2)]
        result = {'subtype':subtype, 'areas':areas, 'list_a':groups[0], 'list_b':groups[1]}
    elif subtype == 5:
        area, total, count = read('HBB')
        points = []
        for _ in range(count):
            x, y, z, state = read('HHBB')
            if state not in (0, 1):
                raise ValueError('Unknown viewpoint state')
            points.append({'x':x,'y':y,'z':z,'state':state})
        result = {'subtype':subtype, 'subarea':area, 'total':total, 'points':points}
    elif subtype == 10:
        result = {'subtype':subtype, 'area':read('H')}
    else:
        raise ValueError('Not a discovery subtype')
    if pos != len(data):
        raise ValueError('Trailing discovery bytes')
    return result


if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('packet',type=Path)
    args=parser.parse_args()
    try:
        print(decode_packet(args.packet.read_bytes()))
    except (ValueError,OSError) as error:
        parser.exit(1,f'FAIL: {error}\n')
