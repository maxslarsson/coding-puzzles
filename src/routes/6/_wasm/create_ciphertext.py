import sys

if len(sys.argv) != 2:
    sys.stderr.write("Usage: ./create_ciphertext.py [PLAINTEXT]")
    sys.exit(1)

for c in sys.argv[1] + "\n":
    print(f"\{hex(ord(c) ^ 17)[2:]}", end="")

print()

print(f"The ciphertext is {len(sys.argv[1])+1} bytes long")

