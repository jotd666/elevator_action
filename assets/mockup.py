from PIL import Image,ImageOps

with open("elevator_ram","rb") as f:
    contents = f.read()


##;    map(0xc400, 0xc7ff).ram().share(m_videoram[0]);
##;    map(0xc800, 0xcbff).ram().share(m_videoram[1]);
##;    map(0xcc00, 0xcfff).ram().share(m_videoram[2]);
##;    map(0xd000, 0xd05f).ram().share(m_colscrolly); 0x20 values per layer
##;    map(0xd100, 0xd1ff).ram().share(m_spriteram);
##;    map(0xd200, 0xd27f).mirror(0x0080).ram().share(m_paletteram);

tiles_1 = Image.open("elevator/gfx dev 0 set 0 tiles 8x8 colors 8 pal 00.png")

side = 8
nb_rows = tiles_1.size[1] // side
nb_cols = tiles_1.size[0] // side

dumpdir = "dumps"

tileset_1 = []
k=0
for j in range(nb_rows):
    for i in range(nb_cols):
        img = Image.new("RGB",(side,side))
        img.paste(tiles_1,(-i*side,-j*side))
        tileset_1.append(img)
        img = ImageOps.scale(img,5,resample=Image.Resampling.NEAREST)
        img.save(f"dumps/tile_{k:02x}.png")
        k += 1
layer_nb_rows = 32
layer_nb_cols = 30
layer_1 = Image.new("RGB",(layer_nb_rows*side,layer_nb_cols*side))

current_x = 0
current_y = 0
for addr in range(0xC400,0xC800):
    c = contents[addr-0x8000]
    img = tileset_1[c]
    layer_1.paste(img,(current_x,current_y))
    current_x += side
    if current_x == layer_nb_rows*side:
        current_x = 0
        current_y += side

layer_1.save("layer1.png")

