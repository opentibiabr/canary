"""Bounded protobuf wire walker for Cyclopedia catalog export."""

def protobuf_fields(data):
    """Generic wire walker, without asserting an unverified asset schema."""
    position = 0

    def varint():
        nonlocal position
        value = 0
        for shift in range(0, 70, 7):
            if position >= len(data):
                raise ValueError("Truncated asset varint")
            byte = data[position]
            position += 1
            value |= (byte & 127) << shift
            if byte < 128:
                return value
        raise ValueError("Oversized asset varint")

    fields = []
    while position < len(data):
        key = varint()
        number, wire = key >> 3, key & 7
        if number == 0:
            raise ValueError("Invalid asset field number")
        if wire == 0:
            value = varint()
        elif wire in (1, 2, 5):
            size = varint() if wire == 2 else (8 if wire == 1 else 4)
            if position + size > len(data):
                raise ValueError("Truncated asset field")
            value = data[position:position + size]
            position += size
        else:
            raise ValueError(f"Unsupported asset wire type {wire}")
        fields.append((number, wire, value))
    return fields
