from __future__ import annotations

import binascii
import hashlib
import lzma
import struct
import zlib
from dataclasses import dataclass
from pathlib import Path
from typing import Any

SHEET_SIZE = 384
PIXEL_BYTES = 4
SHEET_RGBA_SIZE = SHEET_SIZE * SHEET_SIZE * PIXEL_BYTES
CIP_HEADER_SIZE = 32
CIP_SIGNATURE = b"\x70\x0a\xfa\x80\x24"
MAX_DECOMPRESSED_SIZE = 8 * 1024 * 1024

LAYOUT_SIZES: tuple[tuple[int, int], ...] = (
    (32, 32),
    (32, 64),
    (64, 32),
    (64, 64),
    (32, 96),
    (32, 128),
    (32, 192),
    (32, 384),
    (64, 96),
    (64, 128),
    (64, 192),
    (64, 384),
    (96, 32),
    (96, 64),
    (96, 96),
    (96, 128),
    (96, 192),
    (96, 384),
    (128, 32),
    (128, 64),
    (128, 96),
    (128, 128),
    (128, 192),
    (128, 384),
    (192, 32),
    (192, 64),
    (192, 96),
    (192, 128),
    (192, 192),
    (192, 384),
    (384, 32),
    (384, 64),
    (384, 96),
    (384, 128),
    (384, 192),
    (384, 384),
)


class SpriteSheetError(ValueError):
    pass


@dataclass(frozen=True)
class CipHeader:
    signature_offset: int
    declared_lzma_size: int
    properties: int
    lc: int
    lp: int
    pb: int
    dictionary_size: int
    declared_compressed_size: int


@dataclass(frozen=True)
class DecodedSheet:
    source: Path
    source_sha256: str
    source_size: int
    header: CipHeader
    bmp_data_offset: int
    width: int
    height: int
    rgba: bytes
    magenta_pixels: int


@dataclass(frozen=True)
class ExtractedSprite:
    sprite_id: int
    first_sprite_id: int
    last_sprite_id: int
    layout: int
    width: int
    height: int
    column: int
    row: int
    rgba: bytes


def _sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        while chunk := stream.read(4 * 1024 * 1024):
            digest.update(chunk)
    return digest.hexdigest()


def _decode_7bit_integer(data: bytes, offset: int, end: int) -> tuple[int, int]:
    value = 0
    shift = 0
    for _ in range(10):
        if offset >= end:
            raise SpriteSheetError("CIP size varint is truncated")
        byte = data[offset]
        offset += 1
        value |= (byte & 0x7F) << shift
        if not byte & 0x80:
            return value, offset
        shift += 7
    raise SpriteSheetError("CIP size varint exceeds ten bytes")


def _parse_cip_header(data: bytes) -> CipHeader:
    if len(data) < CIP_HEADER_SIZE + 13:
        raise SpriteSheetError("Sprite sheet is too small for CIP and LZMA headers")
    header = data[:CIP_HEADER_SIZE]
    signature_offset = header.find(CIP_SIGNATURE)
    if signature_offset < 0:
        raise SpriteSheetError("CIP signature is missing")
    if header.find(CIP_SIGNATURE, signature_offset + 1) >= 0:
        raise SpriteSheetError("CIP signature appears more than once")
    if any(header[:signature_offset]):
        raise SpriteSheetError("CIP padding before the signature must contain only zero bytes")
    size_offset = signature_offset + len(CIP_SIGNATURE)
    declared_lzma_size, size_end = _decode_7bit_integer(header, size_offset, CIP_HEADER_SIZE)
    if size_end != CIP_HEADER_SIZE:
        raise SpriteSheetError("CIP size varint must end at byte 32")
    actual_lzma_size = len(data) - CIP_HEADER_SIZE
    if declared_lzma_size != actual_lzma_size:
        raise SpriteSheetError(
            f"CIP LZMA size mismatch: declared {declared_lzma_size}, actual {actual_lzma_size}"
        )

    properties = data[CIP_HEADER_SIZE]
    if properties >= 9 * 5 * 5:
        raise SpriteSheetError(f"Invalid LZMA properties byte: {properties}")
    lc = properties % 9
    remainder = properties // 9
    lp = remainder % 5
    pb = remainder // 5
    if lc + lp > 4:
        raise SpriteSheetError(f"Invalid LZMA lc/lp combination: lc={lc}, lp={lp}")
    dictionary_size = struct.unpack_from("<I", data, CIP_HEADER_SIZE + 1)[0]
    if dictionary_size == 0:
        raise SpriteSheetError("LZMA dictionary size must be greater than zero")
    declared_compressed_size = struct.unpack_from("<Q", data, CIP_HEADER_SIZE + 5)[0]
    actual_compressed_size = len(data) - CIP_HEADER_SIZE - 13
    if declared_compressed_size != actual_compressed_size:
        raise SpriteSheetError(
            f"LZMA compressed size mismatch: declared {declared_compressed_size}, actual {actual_compressed_size}"
        )
    return CipHeader(
        signature_offset=signature_offset,
        declared_lzma_size=declared_lzma_size,
        properties=properties,
        lc=lc,
        lp=lp,
        pb=pb,
        dictionary_size=dictionary_size,
        declared_compressed_size=declared_compressed_size,
    )


def _decompress_lzma(data: bytes, header: CipHeader) -> bytes:
    compressed = data[CIP_HEADER_SIZE + 13 :]
    filters = [
        {
            "id": lzma.FILTER_LZMA1,
            "dict_size": header.dictionary_size,
            "lc": header.lc,
            "lp": header.lp,
            "pb": header.pb,
        }
    ]
    try:
        decoder = lzma.LZMADecompressor(format=lzma.FORMAT_RAW, filters=filters)
        decoded = decoder.decompress(compressed, max_length=MAX_DECOMPRESSED_SIZE + 1)
    except lzma.LZMAError as exc:
        raise SpriteSheetError(f"LZMA decompression failed: {exc}") from exc
    if len(decoded) > MAX_DECOMPRESSED_SIZE:
        raise SpriteSheetError(f"Decompressed data exceeds {MAX_DECOMPRESSED_SIZE} bytes")
    if not decoder.eof:
        raise SpriteSheetError("LZMA stream did not reach its end marker")
    if decoder.unused_data:
        raise SpriteSheetError("LZMA stream contains trailing compressed data")
    return decoded


def _decode_bmp(data: bytes) -> tuple[int, int, int, bytes, int]:
    if len(data) < 54 or data[:2] != b"BM":
        raise SpriteSheetError("Decompressed sprite sheet is not a BMP file")
    file_size = struct.unpack_from("<I", data, 2)[0]
    pixel_offset = struct.unpack_from("<I", data, 10)[0]
    dib_size = struct.unpack_from("<I", data, 14)[0]
    if dib_size < 40 or 14 + dib_size > len(data):
        raise SpriteSheetError(f"Unsupported or truncated BMP DIB header: {dib_size}")
    width = struct.unpack_from("<i", data, 18)[0]
    raw_height = struct.unpack_from("<i", data, 22)[0]
    planes = struct.unpack_from("<H", data, 26)[0]
    bits_per_pixel = struct.unpack_from("<H", data, 28)[0]
    compression = struct.unpack_from("<I", data, 30)[0]
    if width != SHEET_SIZE or abs(raw_height) != SHEET_SIZE:
        raise SpriteSheetError(f"Expected a {SHEET_SIZE}x{SHEET_SIZE} BMP, got {width}x{raw_height}")
    if planes != 1 or bits_per_pixel != 32 or compression not in {0, 3}:
        raise SpriteSheetError(
            f"Expected 32-bit uncompressed BMP pixels, got planes={planes}, bpp={bits_per_pixel}, compression={compression}"
        )
    if file_size not in {0, len(data)}:
        raise SpriteSheetError(f"BMP file size mismatch: header {file_size}, actual {len(data)}")
    row_stride = ((width * bits_per_pixel + 31) // 32) * 4
    required = pixel_offset + row_stride * abs(raw_height)
    if pixel_offset < 14 + dib_size or required > len(data):
        raise SpriteSheetError("BMP pixel data is out of bounds")

    output = bytearray(SHEET_RGBA_SIZE)
    magenta_pixels = 0
    bottom_up = raw_height > 0
    for output_y in range(SHEET_SIZE):
        source_y = SHEET_SIZE - 1 - output_y if bottom_up else output_y
        source_row = pixel_offset + source_y * row_stride
        output_row = output_y * SHEET_SIZE * PIXEL_BYTES
        for x in range(SHEET_SIZE):
            source = source_row + x * PIXEL_BYTES
            target = output_row + x * PIXEL_BYTES
            blue, green, red, alpha = data[source : source + 4]
            if red == 0xFF and green == 0x00 and blue == 0xFF:
                output[target : target + 4] = b"\0\0\0\0"
                magenta_pixels += 1
            else:
                output[target : target + 4] = bytes((red, green, blue, alpha))
    return pixel_offset, width, abs(raw_height), bytes(output), magenta_pixels


def decode_sprite_sheet(path: Path) -> DecodedSheet:
    source = path.resolve()
    if not source.is_file():
        raise FileNotFoundError(f"Sprite sheet does not exist: {source}")
    data = source.read_bytes()
    header = _parse_cip_header(data)
    bmp = _decompress_lzma(data, header)
    pixel_offset, width, height, rgba, magenta_pixels = _decode_bmp(bmp)
    return DecodedSheet(
        source=source,
        source_sha256=_sha256(source),
        source_size=len(data),
        header=header,
        bmp_data_offset=pixel_offset,
        width=width,
        height=height,
        rgba=rgba,
        magenta_pixels=magenta_pixels,
    )


def layout_size(layout: int) -> tuple[int, int]:
    if isinstance(layout, bool) or not isinstance(layout, int) or not 0 <= layout < len(LAYOUT_SIZES):
        raise SpriteSheetError(f"Sprite layout must be an integer from 0 to {len(LAYOUT_SIZES) - 1}")
    return LAYOUT_SIZES[layout]


def extract_sprite(
    sheet: DecodedSheet,
    *,
    sprite_id: int,
    first_sprite_id: int,
    last_sprite_id: int,
    layout: int,
) -> ExtractedSprite:
    width, height = layout_size(layout)
    if not all(isinstance(value, int) and not isinstance(value, bool) for value in (sprite_id, first_sprite_id, last_sprite_id)):
        raise SpriteSheetError("Sprite IDs must be integers")
    if first_sprite_id > last_sprite_id:
        raise SpriteSheetError("Sprite range is reversed")
    if not first_sprite_id <= sprite_id <= last_sprite_id:
        raise SpriteSheetError(f"Sprite ID {sprite_id} is outside {first_sprite_id}..{last_sprite_id}")
    columns = SHEET_SIZE // width
    rows = SHEET_SIZE // height
    capacity = columns * rows
    offset = sprite_id - first_sprite_id
    if offset >= capacity:
        raise SpriteSheetError(
            f"Sprite ID {sprite_id} has sheet offset {offset}, but layout {layout} capacity is {capacity}"
        )
    column = offset % columns
    row = offset // columns
    sprite = bytearray(width * height * PIXEL_BYTES)
    for y in range(height):
        source = ((row * height + y) * SHEET_SIZE + column * width) * PIXEL_BYTES
        target = y * width * PIXEL_BYTES
        sprite[target : target + width * PIXEL_BYTES] = sheet.rgba[source : source + width * PIXEL_BYTES]
    return ExtractedSprite(
        sprite_id=sprite_id,
        first_sprite_id=first_sprite_id,
        last_sprite_id=last_sprite_id,
        layout=layout,
        width=width,
        height=height,
        column=column,
        row=row,
        rgba=bytes(sprite),
    )


def _png_chunk(chunk_type: bytes, payload: bytes) -> bytes:
    checksum = binascii.crc32(chunk_type)
    checksum = binascii.crc32(payload, checksum) & 0xFFFFFFFF
    return struct.pack(">I", len(payload)) + chunk_type + payload + struct.pack(">I", checksum)


def encode_png(width: int, height: int, rgba: bytes) -> bytes:
    if width <= 0 or height <= 0 or len(rgba) != width * height * PIXEL_BYTES:
        raise SpriteSheetError("PNG dimensions do not match RGBA data")
    scanlines = bytearray()
    row_size = width * PIXEL_BYTES
    for y in range(height):
        scanlines.append(0)
        start = y * row_size
        scanlines.extend(rgba[start : start + row_size])
    header = struct.pack(">IIBBBBB", width, height, 8, 6, 0, 0, 0)
    return (
        b"\x89PNG\r\n\x1a\n"
        + _png_chunk(b"IHDR", header)
        + _png_chunk(b"IDAT", zlib.compress(bytes(scanlines), level=9))
        + _png_chunk(b"IEND", b"")
    )


def sheet_report(sheet: DecodedSheet) -> dict[str, Any]:
    return {
        "format": "canary-sprite-sheet-report-v1",
        "ok": True,
        "source": {
            "path": str(sheet.source),
            "size": sheet.source_size,
            "sha256": sheet.source_sha256,
        },
        "cip": {
            "signatureOffset": sheet.header.signature_offset,
            "declaredLzmaSize": sheet.header.declared_lzma_size,
        },
        "lzma": {
            "properties": sheet.header.properties,
            "lc": sheet.header.lc,
            "lp": sheet.header.lp,
            "pb": sheet.header.pb,
            "dictionarySize": sheet.header.dictionary_size,
            "declaredCompressedSize": sheet.header.declared_compressed_size,
        },
        "bmp": {
            "width": sheet.width,
            "height": sheet.height,
            "pixelDataOffset": sheet.bmp_data_offset,
            "rgbaBytes": len(sheet.rgba),
            "magentaPixelsMadeTransparent": sheet.magenta_pixels,
        },
    }
