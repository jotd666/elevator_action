from PIL import Image,ImageOps
import os,bitplanelib

this_dir = os.path.dirname(os.path.abspath(__file__))

# AGA version uses dual playfield 16+16 plus AGA sprites for elevators (with palette tricks)
# status can use any palette (in game) as copper can reload building palette
# building palette changes with levels. There are 4 versions of building palettes. We'll cheat as the
# game palette is 64 colors but doesn't really use that much
#
# Front playfield displays the building
# Back/front playfield displays the sprites (sprites can be behind in stairs, DPF is a nice way to handle this)
# Sprites display the elevators, with lowest priority

##;    map(0xc400, 0xc7ff).ram().share(m_videoram[0]);
##;    map(0xc800, 0xcbff).ram().share(m_videoram[1]);
##;    map(0xcc00, 0xcfff).ram().share(m_videoram[2]);
##;    map(0xd000, 0xd05f).ram().share(m_colscrolly); 0x20 values per layer
##;    map(0xd100, 0xd1ff).ram().share(m_spriteram);
##;    map(0xd200, 0xd27f).mirror(0x0080).ram().share(m_paletteram);

side = 8
transparent = (254,254,254)  # not possible to get it in the game

# for each layer, very few tiles are used. Don't generate all tiles with the given colors,
# just the ones that are used
# lists below may be incomplete
used_game_tiles = {"status":set(range(16,52)),"building":set(range(64,94)) | {148,157,
  160,
  166,
  167,
  168,
  169,
  197},"elevators":{252, 55, 56, 58, 59, 60, 61, 62, 63}}

used_title_tiles = {"status":set(range(16,52)),
"big_letters": set(range(80,128)) | {158} | set(range(181,256)),
"elevator_letters": set(range(128,181)) | {248, 249}}

game_layer_names = ["status","building","elevators"]
title_layer_names = ["status","big_letters","elevator_letters"]

tile_palettes = []
game_palettes = []

dumpdir = os.path.join(this_dir,os.pardir,"dumps")

def ensure_empty(d):
    if os.path.exists(d):
        for f in os.listdir(d):
            os.remove(os.path.join(d,f))
    else:
        os.makedirs(d)

def load_tileset(image_name,game_gfx,side,used_tiles,tileset_name,dump=False):
    tile_type = "game" if game_gfx else "title"
    full_image_path = os.path.join(this_dir,os.path.pardir,"elevator",
                        tile_type,image_name)
    tiles_1 = Image.open(full_image_path)
    nb_rows = tiles_1.size[1] // side
    nb_cols = tiles_1.size[0] // side


    tileset_1 = []
    k=0

    if dump:
        dump_subdir = os.path.join(dumpdir,tile_type,tileset_name)
        ensure_empty(dump_subdir)

    tile_number = 0
    for j in range(nb_rows):
        for i in range(nb_cols):
            tile_number += 1
            if used_tiles and tile_number-1 not in used_tiles:
                tileset_1.append(None)
                continue

            img = Image.new("RGBA",(side,side))
            img.paste(tiles_1,(-i*side,-j*side))
            tileset_1.append(img)
            if dump:
                img = ImageOps.scale(img,5,resample=Image.Resampling.NEAREST)
                img.save(os.path.join(dump_subdir,f"{k:02x}.png"))
            k += 1

    palette = bitplanelib.palette_extract(tiles_1)
    return sorted(set(palette)),tileset_1

dump_it = True

game_layer = [load_tileset(f"tiles_{i}.png",True,side,used_game_tiles[layer_name],layer_name,dump=dump_it) for i,layer_name in enumerate(game_layer_names)]


sprites_palette,sprites_set = load_tileset("sprites_4.png",True,16,None,"sprites",dump=dump_it)

# sprites can be on either playfield.

playfield_1_palette = game_layer[1][0]
playfield_1_palette = game_layer[1][0]

title_layer = [load_tileset("tiles_{}.png".format(i if i<2 else 1),False,side,used_title_tiles[layer_name],layer_name,dump=dump_it) for i,layer_name in enumerate(title_layer_names)]


