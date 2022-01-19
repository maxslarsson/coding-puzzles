import sys

def main():
    if len(sys.argv) != 3:
        sys.stderr.write("Usage: ./encode_png.py [PNG_FILE_PATH] [OUT_PATH]")
        sys.exit(1)

    with open(sys.argv[1], "rb") as f:
        contents = list(f.read())

    while len(contents) % 8 != 0:
        contents.append(0)

    key = input("What should the key be? ")

    LEN = 8

    if len(key) != LEN:
        sys.stderr.write("Key must be 8 characters long")
        sys.exit(1)

    for i in range(LEN):
        shifter = ord(key[i])
        for j in range(len(contents)//LEN):
            index = (j * LEN) + i;
            contents[index] = contents[index] ^ shifter

    contents = [str(e) for e in contents]

    with open(sys.argv[2], "w") as f:
        f.write(" ".join(contents))


if __name__ == "__main__":
    main()
