from PIL import Image,ImageOps

with open("elevator_ram","rb") as f:
    contents = f.read()


##;    map(0xc400, 0xc7ff).ram().share(m_videoram[0]);
##;    map(0xc800, 0xcbff).ram().share(m_videoram[1]);
##;    map(0xcc00, 0xcfff).ram().share(m_videoram[2]);
##;    map(0xd000, 0xd05f).ram().share(m_colscrolly); 0x20 values per layer
##;    map(0xd100, 0xd1ff).ram().share(m_spriteram);
##;    map(0xd200, 0xd27f).mirror(0x0080).ram().share(m_paletteram);

side = 8
transparent = (254,254,254)  # not possible to get it in the game

blank_image = Image.new("RGB",(side,side))
for i in range(side):
    for j in range(side):
        blank_image.putpixel((i,j),transparent)


def load_tileset(image_name,side,dump_prefix=""):
    tiles_1 = Image.open(image_name)
    nb_rows = tiles_1.size[1] // side
    nb_cols = tiles_1.size[0] // side

    dumpdir = "dumps"

    tileset_1 = []
    k=0
    for j in range(nb_rows):
        for i in range(nb_cols):
            img = Image.new("RGBA",(side,side))
            img.paste(tiles_1,(-i*side,-j*side))
            tileset_1.append(img)
            if dump_prefix:
                img = ImageOps.scale(img,5,resample=Image.Resampling.NEAREST)
                img.save(f"dumps/{dump_prefix}_{k:02x}.png")
            k += 1

    return tileset_1

def create_layer(tileset,address):
    layer_number = (address-0xC000)//0x400
    layer_nb_rows = 32
    layer_nb_cols = 30
    layer_1 = Image.new("RGBA",(layer_nb_rows*side,layer_nb_cols*side))

    current_x = 0
    current_y = 0
    for addr in range(address,address+0x400):
        c = contents[addr-0x8000]
        if c:
            img = tileset[c]
            layer_1.paste(img,(current_x,current_y))

        current_x += side
        if current_x == layer_nb_rows*side:
            current_x = 0
            current_y += side
    return layer_1


tileset_1 = load_tileset("elevator/tiles_0.png",side)
layer_1 = create_layer(tileset_1,0xC400)
#layer_1.save("layer1.png")

tileset_2 = load_tileset("elevator/tiles_1.png",side)
layer_2 = create_layer(tileset_2,0xC800)
#layer_2.save("layer2.png")

tileset_3 = load_tileset("elevator/tiles_2.png",side)
layer_3 = create_layer(tileset_3,0xCC00)
#layer_3.save("layer3.png")

all_layers = Image.new("RGBA",layer_1.size)

all_layers.paste(layer_3,(0,0),layer_3)
all_layers.paste(layer_2,(0,0),layer_2)
all_layers.paste(layer_1,(0,-16),layer_1)

# sprites at D100
# X,Y,attribute (0,1 X flip) and code starting from 0x40

sprites_pic = "elevator/sprites_4.png"
sprites_set = load_tileset(sprites_pic,16,"sprite")

for sprite_address in range(0xD100,0xD200,4):
    block = contents[sprite_address-0x8000:sprite_address-0x8000+4]
    x,y,attribute,code = block

    code -= 0x40
    y = 240-y
    sprite = sprites_set[code]

    all_layers.paste(sprite,(x,y))


all_layers.save("all.png")