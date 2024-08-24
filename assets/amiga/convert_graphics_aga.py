# TODO:
# - wrong colors for muzzle flash for spies with alternate cluts (dark, lights out)
#   => generate those sprite tiles from the original, not from the alternate sprite sheet
#      using 2 color replaces
# - identify dynamic colors per level (4 sets)
# - identify which colors to change when lights are shot

from PIL import Image,ImageOps
import os,sys,bitplanelib

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

varying_palettes = [
# level 1
((255,176,218),  # pink, inside elevator
(37,176,176),  # blue, walls
(37,117,117),  # elevator background (around wire)
),
# level 2
((167,242,242),  # cyan, inside elevator
(207,231,207),   # pink, walls
(242,207,242)),  # light pink, elevator background
# level 3
((242,131,167),  # pink, inside elevator
(207,242,242),   # light gray, walls
(0,167,207)),  # light blue, elevator background
# level 4
((35,207,207),  # pink, inside elevator
(131,131,131),   # light gray, walls
(1,1,1)),  # black, elevator background
]

for v in varying_palettes:
    inside_elevator = v[0]   # dynamic => change to existing gray, change on Y
    outside_elevator = v[2]  # background => change to black, change background on Y
    elevator_shade = (37,37,37)
    elevator_cable_gray = (176,176,176)
    elevator_floor_gray = (218,218,218)


varying_palettes_rgb4 = [
[bitplanelib.to_rgb4_color(x) for x in lst] for lst in varying_palettes]

#varying_palettes_rgb4_str = [
#["{:03x}".format(bitplanelib.to_rgb4_color(x)) for x in lst] for lst in varying_palettes]

# 167,131,242: color behind the doors (when doors are opening)

side = 8
transparent = (254,0,254)  # not possible to get it in the game
dummy = (1,1,1)  # not possible to get it in the game

def dump_asm_bytes(*args,**kwargs):
    bitplanelib.dump_asm_bytes(*args,**kwargs,mit_format=True)

# for each layer, very few tiles are used. Don't generate all tiles with the given colors,
# just the ones that are used
# lists below may be incomplete
used_game_tiles = {"status":set(range(16,52)) | {1} | set(range(0xE0,0x100)),
  "building":set(range(64,94)) | set(range(0xB0,0xBB)) | {148,157,
  160,
  166,
  167,
  168,
  169,
  197,
  0x98,0x99,0x9A,0x9B,0x9C,0xFD,0xFE,  # grappling hook
  0x81,0x8C,0x88,0x89,0x85,0x8A,0x8B,
  },"elevators":{252, 55, 56, 58, 59, 60, 61, 62, 63}}

used_title_tiles = {"status":set(range(16,50)) | {6,7,8,51,0x4F},
"big_letters": set(range(80,128)) | {64,0x4B,0x4C,0x4D,0x4E,0x94} | set(range(158,256)),
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

def load_tileset(image_name,game_gfx,side,used_tiles,tileset_name,dump=False,name_dict=None):
    tile_type = "game" if game_gfx else "title"

    if isinstance(image_name,str):
        full_image_path = os.path.join(this_dir,os.path.pardir,"elevator",
                            tile_type,image_name)
        tiles_1 = Image.open(full_image_path)
    else:
        tiles_1 = image_name
    nb_rows = tiles_1.size[1] // side
    nb_cols = tiles_1.size[0] // side


    tileset_1 = []

    if dump:
        dump_subdir = os.path.join(dumpdir,tile_type,tileset_name)
        ensure_empty(dump_subdir)

    tile_number = 0
    palette = set()

    for j in range(nb_rows):
        for i in range(nb_cols):
            if used_tiles and tile_number not in used_tiles:
                tileset_1.append(None)
            else:

                img = Image.new("RGB",(side,side))
                img.paste(tiles_1,(-i*side,-j*side))

                # only consider colors of used tiles
                palette.update(set(bitplanelib.palette_extract(img)))


                tileset_1.append(img)
                if dump:
                    img = ImageOps.scale(img,5,resample=Image.Resampling.NEAREST)
                    if name_dict:
                        name = name_dict.get(tile_number,"unknown")
                    else:
                        name = "unknown"

                    img.save(os.path.join(dump_subdir,f"{name}_{tile_number:02x}.png"))

            tile_number += 1

    return sorted(set(palette)),tileset_1

dump_it = True

title_layer = [load_tileset("tiles_{}.png".format(i if i<2 else 1),False,side,
                used_title_tiles[layer_name],layer_name,dump=dump_it) for i,layer_name in enumerate(title_layer_names)]

title_letters_palette = tuple(title_layer[2][0])
# title playfield starts with letters palette (sprites) then continues with regular tiles
title_playfield_palette = title_letters_palette + tuple(sorted(set(x for tl in title_layer[0:2] for x in tl[0])))[1:]
title_playfield_palette = title_playfield_palette + (16-len(title_playfield_palette)) * (dummy,)


game_layer = [load_tileset(f"tiles_{i}.png",True,side,used_game_tiles[layer_name],layer_name,dump=dump_it) for i,layer_name in enumerate(game_layer_names)]

# insert black color to elevator layer
game_layer[2][0].insert(0,(0,0,0))

sprite_names = dict()


def change_color(img,color1,color2):
    rval = Image.new("RGB",img.size)
    for x in range(img.size[0]):
        for y in range(img.size[1]):
            p = img.getpixel((x,y))
            if p==color1:
                p = color2
            rval.putpixel((x,y),p)
    return rval

def add_sprite_range(start,end,name,namedict=sprite_names):
    for i in range(start,end):
        namedict[i] = name

# better name sprites, as some color hacks are needed (black color is used for spies and lamps)
add_sprite_range(0,16,"player")
add_sprite_range(16,32,"enemy")
add_sprite_range(32,40,"red_door")
add_sprite_range(43,48,"car")
add_sprite_range(48,50,"player_shoots")
add_sprite_range(50,56,"enemy_shoots")
add_sprite_range(56,58,"shot")
add_sprite_range(59,61,"player")
add_sprite_range(61,62,"exclamation")
add_sprite_range(62,64,"lamp")

alt_sprite_names = dict()
# add 2 special enemy "cluts" and blue opening door
#add_sprite_range(16,32,"enemy_lights_out",namedict=alt_sprite_names)
add_sprite_range(16,32,"enemy_dark_floor",namedict=alt_sprite_names)
add_sprite_range(50,56,"enemy_dark_floor_shoots",namedict=alt_sprite_names)
add_sprite_range(32,40,"blue_door",namedict=alt_sprite_names)


sprites_path = os.path.join(this_dir,os.path.pardir,"elevator","game")
sprites_1_sheet = Image.open(os.path.join(sprites_path,"sprites_4.png"))
sprites_2_sheet = Image.open(os.path.join(sprites_path,"sprites_5.png"))
# make a color correspondence dictionary
color_translation_dict = {}


for x in range(sprites_1_sheet.size[0]):
    for y in range(sprites_1_sheet.size[1]):
        p1 = sprites_1_sheet.getpixel((x,y))
        # ignore black from sprite 2
        p2 = sprites_2_sheet.getpixel((x,y))
        if p2==p1==(0,0,0):
            continue
        if p1 == (0,0,0):
            p1 = dummy
        color_translation_dict[p2] = p1

# one problem is: spies and lamps are black, and the main sheet (sprites_4) has proper colors for all sprites
# but transparent color is black (when dumped with MAME gfx save)
# we have to rebuild the sprite sheet with magenta (for instance) as transparent color
#
# consider the sprite sheet 2 which has all differentiated colors, but most are wrong, and convert black to pink
sprites_2_sheet = change_color(sprites_2_sheet,(0,0,0),transparent)
# now just apply inverse conversion, with a step using dummy to make sure we don't lose
# black enemy bodies and other black parts that are missing from sprite sheet 1
for x in range(sprites_2_sheet.size[0]):
    for y in range(sprites_2_sheet.size[1]):
        p = sprites_2_sheet.getpixel((x,y))
        # ignore black from sprite 2
        p = color_translation_dict.get(p)
        if p:
            sprites_1_sheet.putpixel((x,y),p)
        p = sprites_1_sheet.getpixel((x,y))
        if p==(0,0,0):
            sprites_1_sheet.putpixel((x,y),transparent)
        elif p==dummy:
            sprites_1_sheet.putpixel((x,y),(0,0,0))


sprites_palette,sprites_set = load_tileset(sprites_1_sheet,True,16,None,"sprites",dump=dump_it,name_dict=sprite_names)
# dark floor enemies + blue door
sprites_palette_2,sprites_set_2 = load_tileset(sprites_2_sheet,True,16,set(range(16,40)) | set(range(50,56)),"sprites_alt",dump=dump_it,name_dict=alt_sprite_names)

# create lights out enemies
sprites_3_sheet = change_color(sprites_2_sheet,(0,0,176),(0,0,255))
sprites_3_sheet = change_color(sprites_3_sheet,(79,79,79),(0,0,0))

sprites_palette_3,sprites_set_3 = load_tileset(sprites_3_sheet,True,16,set(range(16,32)) | set(range(50,56)),"lights_out_enemies",dump=dump_it,name_dict=None)

full_sprite_set = sprites_set + sprites_set_2 + sprites_set_3

# playfield+status+sprites
game_playfield_palette = tuple(sorted(set(x for tl in game_layer[0:2] for x in tl[0])))

sprites_palette = tuple(sorted(set(sprites_palette) |
  set(sprites_palette_2) |
  set(sprites_palette_3)))
# elevators
game_background_palette = tuple(sorted(game_layer[2][0]))

nb_game_colors = len(game_playfield_palette)
print(f"nb tiles colors in-game: {nb_game_colors}")
nb_sprites_colors = len(sprites_palette)
print(f"nb sprites colors in-game: {nb_sprites_colors}")
# with elevator colors as sprites, the number of colors is around 14
# we could go down using dynamic color change between status & main
# we'll sort that out later
if nb_game_colors > 16:
    raise Exception("game tiles: max 16 colors allowed")
if nb_sprites_colors > 16:
    raise Exception("sprites: max 16 colors allowed")
game_playfield_palette = game_playfield_palette + (16-len(game_playfield_palette)) * (dummy,)
sprites_palette = sprites_palette + (16-len(sprites_palette)) * (dummy,)

current_plane_idx = 0

layer_bitmaps = {}

nb_planes = 4


for tn,tc in (["title",title_layer],["game",game_layer]):

    layer_bitmaps[tn] = [[] for _ in range(3)]
    for lidx,(_,ts) in enumerate(tc):  # for each layer
        if tn=="title":
            palette = title_playfield_palette
        elif lidx < 2:
            palette = game_playfield_palette
        else:
            palette = game_background_palette

        tile_list = layer_bitmaps[tn][lidx]

        for tidx,tile in enumerate(ts):  # for each tile
            if tile:
                try:
                    planes = bitplanelib.palette_image2raw(tile,None,palette,forced_nb_planes=nb_planes)
                except bitplanelib.BitplaneException as e:
                    print(tn,lidx,tidx,e)
                    print(palette)
                    tile.save("error.png")
                    sys.exit(1)
                    tile_list.append(None)
                    continue

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

#BOBs

bob_list = []
bob_bitplane_cache = dict()
current_plane_idx = 0

for tile in full_sprite_set:
    if tile:
        plane_list = []
        for sym in range(2):
            if sym:
                tile = ImageOps.mirror(tile)
            planes = bitplanelib.palette_image2raw(tile,None,sprites_palette,forced_nb_planes=nb_planes,
            generate_mask=True,blit_pad=True,
            mask_color=transparent)
            planesize = len(planes)//(nb_planes+1)
            for sl in range(0,len(planes),planesize):
                plane = planes[sl:sl+planesize]
                if any(plane):
                    plane_idx = bob_bitplane_cache.get(plane)
                    if plane_idx is None:
                        # create entry
                        plane_idx = current_plane_idx
                        bob_bitplane_cache[plane] = current_plane_idx
                        current_plane_idx += 1
                    plane_list.append(plane_idx)
                else:
                    # empty plane: use index -1
                    plane_list.append(-1)

        bob_list.append(plane_list)
    else:
        bob_list.append(None)

src_dir = os.path.join(this_dir,os.pardir,os.pardir,"src","aga")

# dump palettes
with open(os.path.join(src_dir,"palettes.68k"),"w") as f:
    f.write("level_palettes:\n")
    for i in range(4):
        f.write(f"\t.long\tlevel_palette_{i}\n")
    for i in range(4):
        f.write(f"level_palette_{i}:\n")
        bitplanelib.palette_dump(game_playfield_palette,f,pformat=bitplanelib.PALETTE_FORMAT_ASMGNU)
    f.write("sprites_palette:\n")
    bitplanelib.palette_dump(sprites_palette,f,pformat=bitplanelib.PALETTE_FORMAT_ASMGNU)
    f.write("title_palette:\n")
    bitplanelib.palette_dump(title_playfield_palette,f,pformat=bitplanelib.PALETTE_FORMAT_ASMGNU)
    f.write("elevators_palette:\n")
    bitplanelib.palette_dump(game_layer[2][0],f,pformat=bitplanelib.PALETTE_FORMAT_ASMGNU)


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
                            f.write(f"tile_plane_{t}")
                        f.write("\n")

    f.write("\nbob_table:\n")
    for i,tile in enumerate(bob_list):
        f.write("\t.long\t")
        if tile:
            f.write(f"bob_info_{i}")
        else:
            f.write("0")

        f.write("\n")

    for i,tile in enumerate(bob_list):
        if tile:
            f.write(f"bob_info_{i}:\n")
            for i,p in enumerate(tile):
                if i%(len(tile)//2) == 0:
                    f.write("\t.word\t16,4,0\n") # TODO optimize later (shots, small characters)
                f.write("\t.long\t")
                if p==-1:
                    f.write("0")
                else:
                    f.write(f"bob_plane_{p}")
                f.write("\n")

    f.write("\n* tile bitplanes\n")
    # dump bitplanes
    for k,v in tile_bitplane_cache.items():
        f.write(f"tile_plane_{v}:")
        bitplanelib.dump_asm_bytes(k,f,mit_format=True)

    f.write("\n\t.section\t.datachip\n\n")

    f.write("\n* bob bitplanes\n")
    # dump bitplanes
    for k,v in bob_bitplane_cache.items():
        f.write(f"bob_plane_{v}:")
        bitplanelib.dump_asm_bytes(k,f,mit_format=True)



