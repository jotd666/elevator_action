# TODO:
# - transparent color that is not black (for spies)
# - identify dynamic colors per level (4 sets)
# - identify which colors to change when lights are shot

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
dummy = (1,1,1)  # not possible to get it in the game

def dump_asm_bytes(*args,**kwargs):
    bitplanelib.dump_asm_bytes(*args,**kwargs,mit_format=True)

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

used_title_tiles = {"status":set(range(16,50)) | {51},
"big_letters": set(range(80,128)) | {158} | set(range(181,256)),
"elevator_letters": set(range(128,181)) | {248, 249}}

game_layer_names = ["status","building","elevators"]
title_layer_names = ["status","big_letters","elevator_letters"]

tile_bitplane_cache = dict()

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
    palette = set()

    for j in range(nb_rows):
        for i in range(nb_cols):
            tile_number += 1
            if used_tiles and tile_number-1 not in used_tiles:
                tileset_1.append(None)
                continue

            img = Image.new("RGBA",(side,side))
            img.paste(tiles_1,(-i*side,-j*side))

            # only consider colors of used tiles
            palette.update(set(bitplanelib.palette_extract(img)))
            tileset_1.append(img)
            if dump:
                img = ImageOps.scale(img,5,resample=Image.Resampling.NEAREST)
                img.save(os.path.join(dump_subdir,f"{k:02x}.png"))
            k += 1


    return sorted(set(palette)),tileset_1

dump_it = True

game_layer = [load_tileset(f"tiles_{i}.png",True,side,used_game_tiles[layer_name],layer_name,dump=dump_it) for i,layer_name in enumerate(game_layer_names)]


sprites_palette,sprites_set = load_tileset("sprites_4.png",True,16,None,"sprites",dump=dump_it)

# sprites can be on either playfield.

game_playfield_palette = tuple(sorted(set(game_layer[1][0]+sprites_palette)))
game_playfield_palette = game_playfield_palette + (16-len(game_playfield_palette)) * (dummy,)

title_layer = [load_tileset("tiles_{}.png".format(i if i<2 else 1),False,side,used_title_tiles[layer_name],layer_name,dump=dump_it) for i,layer_name in enumerate(title_layer_names)]

title_playfield_palette = tuple(sorted(set(title_layer[1][0])))
title_playfield_palette = title_playfield_palette + (16-len(title_playfield_palette)) * (dummy,)

current_plane_idx = 0

layer_bitmaps = {}
for tn,tc,palette in (["title",title_layer,title_playfield_palette],["game",game_layer,game_playfield_palette]):
    layer_bitmaps[tn] = [[] for _ in range(3)]
    for lidx,(_,ts) in enumerate(tc):  # for each layer
        tile_list = layer_bitmaps[tn][lidx]

        for tidx,tile in enumerate(ts):  # for each tile
            if tile:
                try:
                    planes = bitplanelib.palette_image2raw(tile,None,palette,forced_nb_planes=4)
                except bitplanelib.BitplaneException as e:
                    print(tn,lidx,tidx,e)
                    tile_list.append(None)
                    continue

                nb_planes = 4
                plane_list = []
                planesize = len(planes)//nb_planes
                for sl in range(0,len(planes),planesize):
                    plane = planes[sl:sl+planesize]
                    if any(plane):
                        plane_idx = tile_bitplane_cache.get(plane)
                        if plane_idx is None:
                            # create entry
                            plane_idx = current_plane_idx
                            tile_bitplane_cache[plane] = current_plane_idx
                            current_plane_idx += 1
                        plane_list.append(plane_idx)
                    else:
                        # empty plane: use index -1
                        plane_list.append(-1)
                tile_list.append(plane_list)
            else:
                tile_list.append(None)


src_dir = os.path.join(this_dir,os.pardir,os.pardir,"src","amiga")

with open(os.path.join(src_dir,"graphics.68k"),"w") as f:
    f.write("\t.global\tcharacter_tables\n")
    f.write("\t.global\tbob_table\n")   # BOBs only present in game

    f.write("""
character_tables:
\t.long\tchar_table_title
\t.long\tchar_table_game
""")

    for tt,lb in layer_bitmaps.items():
        f.write(f"\nchar_table_{tt}:\n")
        for lidx,_ in enumerate(lb):
            layer_entry = f"{tt}_{lidx}_layer"
            f.write(f"\t.long\t{layer_entry}\n")
        for lidx,tile_list in enumerate(lb):
            layer_entry = f"{tt}_{lidx}_layer"
            f.write(f"{layer_entry}:\n")
            for tidx,tile in enumerate(tile_list):
                f.write("\t.long\t")
                f.write(f"tile_{tt}_{lidx}_{tidx}" if tile else "0")
                f.write("\n")
            for tidx,tile in enumerate(tile_list):
                if tile:
                    f.write(f"tile_{tt}_{lidx}_{tidx}:\n")
                    for t in tile:
                        f.write(f"\t.long\t")
                        if t < 0:
                            f.write("0")
                        else:
                            f.write(f"tie_plane_{t}")
                        f.write("\n")

    f.write("\n* tile bitplanes\n")
    # dump bitplanes
    for k,v in tile_bitplane_cache.items():
        f.write(f"tile_plane_{v}:")
        bitplanelib.dump_asm_bytes(k,f,mit_format=True)

    f.write("\n\t.section\t.datachip\n\n")




