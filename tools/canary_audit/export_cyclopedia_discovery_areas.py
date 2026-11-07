"""Export all discovery subarea identities and exact tile masks, independent of donations."""
import argparse
import hashlib
import json
import lzma
from pathlib import Path
import struct

from cyclopedia_asset_wire import protobuf_fields


def export(client, output):
    assets = client / 'assets'
    source = next(assets.glob('map-*.dat'))
    fields = protobuf_fields(source.read_bytes())
    areas = {}
    for n, w, data in fields:
        if (n, w) != (1, 2):
            continue
        fs = protobuf_fields(data)
        v = {n: value for n, w, value in fs}
        areas[v[1]] = {'id':v[1], 'name':v[2].decode(), 'type':v[3],
                        'children':[value for n,w,value in fs if n==4], 'runs':[]}
    for n, w, data in fields:
        if (n, w) != (3, 2):
            continue
        v = {n:value for n,w,value in protobuf_fields(data)}
        if v.get(1) != 0 or v.get(6) not in areas:
            continue
        coordinate = {n:value for n,w,value in protobuf_fields(v[2])}
        compressed = (assets/v[3].decode()).read_bytes()
        if compressed[32:37] != bytes.fromhex('5d00000002'):
            raise ValueError('Unsupported compression header')
        raw = lzma.decompress(compressed[45:], format=lzma.FORMAT_RAW,
                              filters=[{'id':lzma.FILTER_LZMA1,'dict_size':1<<25,'lc':3,'lp':0,'pb':2}])
        width, height, planes, bits = struct.unpack_from('<iiHH',raw,18)
        offset = struct.unpack_from('<I',raw,10)[0]
        if raw[:2]!=b'BM' or bits!=32 or planes!=1 or width!=v[4] or abs(height)!=v[5] or len(raw)!=offset+width*abs(height)*4:
            raise ValueError('Invalid mask layout')
        for row in range(abs(height)):
            stored = abs(height)-row-1 if height>0 else row
            pixels = struct.unpack_from('<'+'I'*width,raw,offset+stored*width*4)
            start=None
            for x in range(width+1):
                value=pixels[x] if x<width else 0
                if value not in (0,0xffffffff):raise ValueError('Invalid mask colour')
                if value and start is None:start=x
                if not value and start is not None:
                    areas[v[6]]['runs'].append([coordinate[3],coordinate[2]+row,coordinate[1]+start,coordinate[1]+x-1])
                    start=None
    for area in areas.values():
        area['runs']=[list(r) for r in sorted(set(tuple(r) for r in area['runs']))]
    output.parent.mkdir(parents=True,exist_ok=True)
    output.write_text(json.dumps({'source_sha256':hashlib.sha256(source.read_bytes()).hexdigest(),
                                  'areas':list(areas.values())},separators=(',',':'),ensure_ascii=False),encoding='utf-8')
    print(f"PASS: {len(areas)} area identities, {sum(bool(a['runs']) for a in areas.values())} masked subareas")


if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('client',type=Path)
    parser.add_argument('output',type=Path)
    args=parser.parse_args()
    export(args.client,args.output)
