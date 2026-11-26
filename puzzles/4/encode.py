# XORs a PNG with a repeating 8-char key and writes the bytes as space-separated decimals
import sys

if len(sys.argv) != 4 or len(sys.argv[2]) != 8:
    sys.exit("Usage: encode.py PNG_FILE KEY(8 chars) OUT_FILE")

png, key, out = sys.argv[1:]

with open(png, "rb") as f:
    data = f.read()
data += bytes(-len(data) % len(key))

with open(out, "w") as f:
    f.write(" ".join(str(b ^ ord(key[i % len(key)])) for i, b in enumerate(data)))
