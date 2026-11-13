"""Validate complete PNG previews before either Store installer writes files."""
import io

from PIL import Image


def validate_png(data):
    if not 8 < len(data) <= 1024 * 1024:
        raise ValueError("PNG preview is empty, truncated or too large")
    # Pillow tolerates a shortened IEND CRC; deployment requires the full file.
    if not data.endswith(b"\x00\x00\x00\x00IEND\xaeB`\x82"):
        raise ValueError("PNG preview has no complete IEND chunk")
    try:
        # verify() checks PNG chunks/CRCs; load() also checks compressed pixels.
        # Reopen after verify(), as required by Pillow's image lifecycle.
        with Image.open(io.BytesIO(data), formats=["PNG"]) as image:
            width, height = image.size
            if not (1 <= width <= 128 and 1 <= height <= 128):
                raise ValueError("Invalid preview dimensions")
            image.verify()
        with Image.open(io.BytesIO(data), formats=["PNG"]) as image:
            for frame in range(image.n_frames):
                image.seek(frame)
                image.load()
    except (OSError, EOFError, SyntaxError, ValueError, Image.DecompressionBombError) as error:
        raise ValueError("Invalid or truncated PNG preview") from error
    return width, height
