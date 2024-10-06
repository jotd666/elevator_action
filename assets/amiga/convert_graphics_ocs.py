from graphics_shared import *
from PIL import Image,ImageOps
import os,sys,bitplanelib


# for title, ECS and AGA versions use the same layout: 16 color + sprites for elevator letters

# for game, ECS version is completely different from AGA.
# uses dual playfield 8+8 plus sprites for player/car (to add more colors)
# some compromises were done on the tiles/bobs but it's still OK
# tiles+BOBs use the upper playfield
# elevators use the lower playfield
#





dumpdir = os.path.join(this_dir,os.pardir,"dumps","ocs")

dump_it = True

title_layer = [load_tileset("tiles_{}.png".format(i if i<2 else 1),False,side,
                used_title_tiles[layer_name],layer_name,dumpdir=dumpdir,dump=dump_it) for i,layer_name in enumerate(title_layer_names)]

title_letters_palette = tuple(title_layer[2][0])
# title playfield starts with letters palette (sprites) then continues with regular tiles
title_playfield_palette = title_letters_palette + tuple(sorted(set(x for tl in title_layer[0:2] for x in tl[0])))[1:]
title_playfield_palette = title_playfield_palette + (16-len(title_playfield_palette)) * (dummy,)


game_layer = [load_tileset(f"tiles_{i}.png",True,side,used_game_tiles[layer_name],layer_name,dump=dump_it,dumpdir=dumpdir,) for i,layer_name in enumerate(game_layer_names)]

# insert black color to elevator layer
elevators_palette = [(0,0,0)]+game_layer[2][0]
elevators_palette = elevators_palette + [(0xF,0xF,0xF)]*(8-len(elevators_palette))

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

sprites_0_sheet = change_color(sprites_0_sheet,(0,0,0),transparent)

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


# take all from main sheet except some tiles that are never present on that CLUT
all_sprites = set(range(64)) - {0x3E,0x2A,0x29,0x28}

# make main character a hardware sprite
hardware_sprites = {k for k,v in sprite_names.items() if any(x in v for x in ["player","car","red_door","wall"])}

all_sprites -= hardware_sprites

sprites_palette,sprites_set = load_tileset(sprites_1_sheet,True,16,all_sprites,"bobs",dumpdir=dumpdir,dump=dump_it,name_dict=sprite_names)

hw_sprites_palette,hw_sprites_set = load_tileset(sprites_1_sheet,True,16,hardware_sprites,"sprites",dumpdir=dumpdir,dump=dump_it,name_dict=sprite_names)

hw_sprites_palette.remove(transparent)

hw_sprites_palette = [transparent]+hw_sprites_palette


hw_sprite_mapping = {
0x40: 0,
0x41: 1,
0x42: 2,
0x43: 3,
0x44: 4,
0x45: 5,
0x46: 6,
0x47: 7,
0x48: 8,
0x49: 9,
0x4A: 0xA,
0x4B: 0xB,
0x4C: 0xC,
0x4D: 0xD,
0x4E: 0xE,
0x4F: 0xF,
1:0xC1,
8:0xC8,
47:0xEF,
48:0xF0,
0x70:0x30,
0x71:0x31,
0x7A:0x3A,
0x7B:0x3B,
0x7C:0x3C,
0x6A:0x6A,
0x68:0x68,
0x69:0x69,
0x6B:0x2B,
0x6C:0x2C,
0x6D:0x2D,
#0x20:0x20,  # wrong
#0x21:0x21,
#0x22:0x22,
#0x23:0x23,
#0x24:0x24,
#0x25:0x25,
#0x26:0x26
}

bob_sprite_mapping = {
0x50:0x10,
0x51:0x11,
0x52:0x12,
0x53:0x13,
0x54:0x14,
0x55:0x15,
0x56:0x16,
0x57:0x17,
0x58:0x18,
0x59:0x19,
0x5A:0x1A,
0x5B:0x1B,
0x5C:0x1C,
0x5d:0x1D,
0x5e:0x1e,
0x5f:0x1f,
0x78:0x38,
0x79:0x39,
0x7F:0x3F,
0x7E:0x7E,  # lamp falling
0x7D:0x3D,
0x72:0x32,
0x73:0x33,
0x74:0x34,
0x75:0x35,
0x76:0x36,
0x77:0x37,
0X60:0x60,  # blue door
0x61:0x61,
0x62:0x62,
0x63:0x63,
0x64:0x64,
0x65:0x65,
0x66:0x66,
0x67:0x67
}

# in right facing car sprite (personal opinion) the windshield background should be
# transparent instead of this brown color that turns player hair into Jackson's five hair.
# bitplanelib.replace_color(hw_sprites_set[0x2F],{(255,218,138)},transparent)

# dark floor enemies + blue door
sprites_palette_2,sprites_set_2 = load_tileset(sprites_2_sheet,True,16,set(range(16,40)) | set(range(50,56)) | {0x3E},"bobs",dump=dump_it,
                                            name_dict=sprite_names,tile_offset=64,dumpdir=dumpdir)


other_sprites = {1,8,48,47}  # body of player holding documents & "500" score points: all those are HW sprites too

_,hw_sprites_set_alt = load_tileset(sprites_0_sheet,True,16,other_sprites,"sprites",dumpdir=dumpdir,dump=dump_it,name_dict=sprite_names,tile_offset=192)
hw_sprites_palette_2,hw_sprites_set_alt_2 = load_tileset(sprites_2_sheet,True,16,{40,41,42},"sprites",dumpdir=dumpdir,dump=dump_it,name_dict=sprite_names,tile_offset=64)

# pad, we only need 8 colors for all HW sprites, because we gathered sprites with similar palettes
hw_sprites_palette += hw_sprites_palette_2
hw_sprites_palette = hw_sprites_palette + [(0x10,0x20,0x30)]*(16-len(hw_sprites_palette))


hw_sprites_set += hw_sprites_set_alt_2 + [None]*64 + hw_sprites_set_alt


full_sprite_set = sprites_set + sprites_set_2
full_sprite_set += [None]*(256-len(full_sprite_set))

# playfield+status+sprites
game_status_palette = tuple(sorted(set(game_layer[0][0])))
game_playfield_palette = tuple(sorted(set(x for tl in game_layer[1:2] for x in tl[0])))

sprites_palette = sorted(set(sprites_palette) |
  set(sprites_palette_2))



nb_game_colors = len(game_playfield_palette)
print(f"nb tiles colors in-game: {nb_game_colors}")
nb_sprites_colors = len(sprites_palette)
print(f"nb bob colors in-game: {nb_sprites_colors}")

total_colors = sorted(set(game_playfield_palette) | set(sprites_palette))
print(f"original nb total colors in game playfield: {len(total_colors)}")

blue = (0,0,200)
brown = (255,218,138)


# we have to severely reduce palette from 17 colors to 7!!
color_replacement_dict = {
(218,218,218):(255,255,255),  # bright gray => white
(255,218,176):brown,  # brown => skin brown
(218,176,138):brown,  # brown => skin brown
(0, 0, 176):blue,
(37, 37, 218):blue,
(0, 0, 255):blue,
(79, 79, 79):(0,0,0),   # dark gray => black
(16, 32, 48):(0,0,0),
(254, 0, 254):(0,0,0),  # magenta is mask
#(37, 176, 176):(0,200,0),   # gun flame, alternate palette also walls...
(176, 117, 0):brown,    # red door edge
(255,218,138):brown
}

game_playfield_palette = sorted({color_replacement_dict.get(x,x) for x in total_colors})

if len(game_playfield_palette)>7:
    raise Exception(f"Too many colors for playfield palette. Needs max 7 found {len(game_playfield_palette)}")
print(f"nb total playfield colors after reduction: {len(game_playfield_palette)}")

# put meaningless color in first pos, dual playfield will ignore it
game_playfield_palette.insert(0,(0x10,0x20,0x30))

# we need to rework all tiles to replace colors, but not magenta which is transparent color
color_replacement_dict.pop((254, 0, 254))

if dump_it:
    new_color_dir = os.path.join(dumpdir,"game","recolored")
    ensure_empty(new_color_dir)

idx = 0

game_tiles = game_layer[1][1]  # list of tiles
for tile in game_tiles+full_sprite_set:
    if tile:
        bitplanelib.replace_color_from_dict(tile,color_replacement_dict)
        tile = ImageOps.scale(tile,5,resample=Image.Resampling.NEAREST)
        tile.save(os.path.join(new_color_dir,f"img_{idx:02x}.png"))
    idx += 1
# the HW sprite we recolored slightly
#tile = ImageOps.scale(hw_sprites_set[0x2F],5,resample=Image.Resampling.NEAREST)
#tile.save(os.path.join(new_color_dir,"facing_car.png"))

current_plane_idx = 0

layer_bitmaps = {}

nb_planes = 3

elev_tiles = game_layer[2][1]



for tn,tc in (["title",title_layer],["game",game_layer]):

    layer_bitmaps[tn] = [[] for _ in range(3)]
    for lidx,(_,ts) in enumerate(tc):  # for each layer
        if tn=="title":
            palette = title_playfield_palette
            the_nb_planes = 4
        elif lidx == 1:
            palette = game_playfield_palette
            the_nb_planes = 3
        elif lidx == 0:
            palette = game_status_palette
            the_nb_planes = 3
        else:
            palette = elevators_palette
            the_nb_planes = 3

        tile_list = layer_bitmaps[tn][lidx]

        for tidx,tile in enumerate(ts):  # for each tile
            if tile:
                try:
                    # depending on the tile, the black color is transparent or black. Transparent is a rare exception
                    # for elevator platforms and upper door background
                    mask_color = (0,0,0) if tidx in {0X4D,0x4E,0x9D} or lidx==0 else game_playfield_palette[0]
                    planes = bitplanelib.palette_image2raw(tile,None,palette,forced_nb_planes=the_nb_planes,mask_color=mask_color)
                except bitplanelib.BitplaneException as e:
                    print(tn,lidx,tidx,e)
                    print(palette)
                    tile.save("error.png")
                    sys.exit(1)
                    tile_list.append(None)
                    continue

                plane_list = []
                planesize = len(planes)//the_nb_planes
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

            y_start,ctile = bitplanelib.autocrop_y(tile,mask_color=transparent)
            height = ctile.size[1]

            planes = bitplanelib.palette_image2raw(ctile,None,game_playfield_palette,forced_nb_planes=nb_planes,
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

        bob_list.append((plane_list,y_start,height))
    else:
        bob_list.append(None)

src_dir = os.path.join(this_dir,os.pardir,os.pardir,"src","ocs")

#dark_color_rep = {(255,0,0):(255,0,0), (255,255,255):(111,111,111), (176, 176, 176):(0,111,167)}


dark_color_rep = {(79,79,79):(0,0,0), (0,0,255):(0,0,176), # enemy skin and blue doors are dark/darker,
 (176, 176, 176):(0,111,167),
 (37,176,176):(0,0,0),
 (255,255,255):(111,111,111)}  # fake building front sprites follow tiles rules

dark_palette = [dark_color_rep.get(c,(0,0,0)) for c in game_playfield_palette]

# dump palettes
with open(os.path.join(src_dir,"palettes.68k"),"w") as f:
    f.write("level_palettes:\n")
    for i in range(4):
        f.write(f"\t.long\tlevel_palette_{i}\n")
    wall_color_index = 6 #game_playfield_palette.index(varying_palettes[0][1]) TEMP
    brick_color_index = 6  #game_playfield_palette.index(varying_palettes[0][3])
    for i in range(4):
        f.write(f"level_palette_{i}:\n")
        p = list(game_playfield_palette)
        if i:
            # must change palette for walls & brick (bottom panel)
            p[wall_color_index] = varying_palettes[i][1]
        bitplanelib.palette_dump(p,f,pformat=bitplanelib.PALETTE_FORMAT_ASMGNU)
    f.write(f"brick_color_index:\n\t.word\tcolor+{brick_color_index*2+32}\n")
    f.write("brick_colors:\n")
    for vp in varying_palettes:
        f.write("\t.word\t0x{:04x}\n".format(bitplanelib.to_rgb4_color(vp[3])))

    f.write("game_status_palette:\n")
    bitplanelib.palette_dump(game_status_palette,f,pformat=bitplanelib.PALETTE_FORMAT_ASMGNU)

    f.write(f"dark_palette:\n")
    bitplanelib.palette_dump(dark_palette,f,pformat=bitplanelib.PALETTE_FORMAT_ASMGNU)
    f.write("playfield_palette:\n")
    # introduce white color as last color (BONUS letters, all planes set)
##    if sprites_palette[15]==dummy:
##        sprites_palette[15] = (0xFF,0xFF,0xFF)
##    else:
##        raise Exception("Not enough colors to insert last white color")
    bitplanelib.palette_dump(game_playfield_palette,f,pformat=bitplanelib.PALETTE_FORMAT_ASMGNU)

    f.write("hw_sprites_palette:\n")
    bitplanelib.palette_dump(hw_sprites_palette,f,pformat=bitplanelib.PALETTE_FORMAT_ASMGNU)

    f.write("title_palette:\n")
    bitplanelib.palette_dump(title_playfield_palette,f,pformat=bitplanelib.PALETTE_FORMAT_ASMGNU)
    f.write("elevators_palette:\n")
    bitplanelib.palette_dump(elevators_palette,f,pformat=bitplanelib.PALETTE_FORMAT_ASMGNU)

    f.write("elevators_dyn_colors:\n")
    for v in varying_palettes_rgb4:
        inside_elevator = v[0]   # dynamic => change to existing gray, change on Y
        outside_elevator = v[2]  # background => change to black, change background on Y
        f.write(f"\t.word\t0x{inside_elevator:04x},0x{outside_elevator:04x}\n")

# hardware sprites
hw_sprites_array = []
for hw_sprite in hw_sprites_set:
    if hw_sprite:
        sp1,sp2 = bitplanelib.palette_image2attached_sprites(hw_sprite,None,hw_sprites_palette)

        sp3,sp4 = bitplanelib.palette_image2attached_sprites(ImageOps.mirror(hw_sprite),None,hw_sprites_palette)
        hw_sprites_array.append([sp1,sp2,sp3,sp4])
    else:
        hw_sprites_array.append(None)

hw_sprites_array = hw_sprites_array + [None]*(256-len(hw_sprites_array))

with open(os.path.join(src_dir,"graphics.68k"),"w") as f:
    f.write("\t.global\tsprite_translation_table\n")
    f.write("\t.global\thw_sprite_table\n")
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

    f.write("\nsprite_translation_table:")

    hw_status = [0]*0x200

    for k,v in hw_sprite_mapping.items():
        hw_status[k*2] = 1
        hw_status[k*2+1] = v
    for k,v in bob_sprite_mapping.items():
        hw_status[k*2] = 2
        hw_status[k*2+1] = v

    bitplanelib.dump_asm_bytes(hw_status,f,mit_format=True)

    f.write("\nhw_sprite_table:\n")
    # dump sprites, we're blessed that we only display one sprite once, no need to dump them 4 times
    for i,hw in enumerate(hw_sprites_array):
        f.write("\t.long\t")
        if hw:
            f.write(",".join(f"hw_sprite_{i}_{j}" for j in range(1,5)))
        else:
            f.write('0,0,0,0')
        f.write("\n")

    f.write("\nbob_table:\n")
    for i,tile in enumerate(bob_list):
        f.write("\t.long\t")
        if tile:
            sn = sprite_names.get(i,"bob_info")
            f.write(f"{sn}_{i:02x}")
        else:
            f.write("0")

        f.write("\n")

    for i,triple in enumerate(bob_list):
        if triple:
            (tile,y_start,height) = triple
            sn = sprite_names.get(i,"bob_info")

            f.write(f"{sn}_{i:02x}:\n")
            for i,p in enumerate(tile):
                if i%(len(tile)//2) == 0:
                    f.write("\t.word\t{},4,{}\n".format(height,y_start))
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


    # HW sprite data
    for i,hw in enumerate(hw_sprites_array):
        if hw:
            for j,sp in enumerate(hw,1):
                f.write(f"hw_sprite_{i}_{j}:")
                bitplanelib.dump_asm_bytes(sp,f,True)




