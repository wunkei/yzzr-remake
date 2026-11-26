import sys
sys.path.insert(0, ".")
from pathlib import Path
from tools.extract_swf_timeline import decode_movie, tag_records
import struct

data, ver, length = decode_movie(Path("yzzr_all_swf/Map888.swf"))

def parse_shape_bounds(payload):
    pos = 0
    b0 = payload[pos]
    nbits = b0 >> 3
    total_bits = 5 + nbits * 4
    total_bytes = (total_bits + 7) // 8
    bits = ""
    for b in payload[pos:pos+total_bytes]:
        bits += f"{b:08b}"
    bits = bits[5:]
    vals = []
    for i in range(4):
        field_bits = bits[i*nbits:(i+1)*nbits]
        v = int(field_bits, 2)
        if field_bits[0] == '1':
            v -= (1 << nbits)
        vals.append(v / 20.0)
    return vals

sprites = {}
shapes = {}
for code, start, end in tag_records(data, 21, len(data)):
    if code == 39:
        s_id, f_cnt = struct.unpack_from("<HH", data, start)
        sprites[s_id] = (start + 4, end, f_cnt)
    elif code in (2, 22, 32, 83):
        s_id = struct.unpack_from("<H", data, start)[0]
        shapes[s_id] = (code, start + 2, end)

print(f"Char 26 in sprites? {26 in sprites}")
if 26 in sprites:
    s_start, s_end, f_cnt = sprites[26]
    for sub_code, sub_start, sub_end in tag_records(data, s_start, s_end):
        if sub_code in (26, 70):
            payload = data[sub_start:sub_end]
            flags = payload[0]
            depth = struct.unpack_from("<H", payload, 1)[0]
            off = 3
            char_id = None
            if flags & 2:
                char_id = struct.unpack_from("<H", payload, off)[0]
            # find string
            name = ""
            for b in payload[off:]:
                if 32 <= b <= 126: name += chr(b)
                elif name: break
            print(f"  depth={depth}, char_id={char_id}, string={name!r}")
            if char_id in shapes:
                b = parse_shape_bounds(data[shapes[char_id][1]:shapes[char_id][2]])
                print(f"    Shape {char_id} bounds: X=[{b[0]}, {b[1]}], Y=[{b[2]}, {b[3]}]")
            elif char_id in sprites:
                print(f"    Sprite {char_id}")
