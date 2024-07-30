import bitplanelib,os

this_dir = os.path.dirname(os.path.abspath(__file__))

# concat gfx rom files to one big file and convert to asm
# requires ROM files from MAME

data = []
for i,s in enumerate(["4","5","9","10"],5):
    with open(os.path.join(this_dir,f"ba3__0{i}.2764.ic{s}"),"rb") as f:
        data.append(f.read())

data = b"".join(data)

with open(os.path.join(this_dir,"../src/gfxrom.68k"),"w") as f:
    f.write("\t.global\tgfxrom\ngfxrom:")
    bitplanelib.dump_asm_bytes(data,f,mit_format=True)