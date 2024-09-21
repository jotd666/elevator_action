from graphics_shared import *
from PIL import Image,ImageOps
import os,sys,bitplanelib


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

#varying_palettes_rgb4_str = [
#["{:03x}".format(bitplanelib.to_rgb4_color(x)) for x in lst] for lst in varying_palettes]

# 167,131,242: color behind the doors (when doors are opening)



dumpdir = os.path.join(this_dir,os.pardir,"dumps","aga")

dump_it = True

title_layer = [load_tileset("tiles_{}.png".format(i if i<2 else 1),False,side,
                used_title_tiles[layer_name],layer_name,dumpdir=dumpdir,dump=dump_it) for i,layer_name in enumerate(title_layer_names)]

title_letters_palette = tuple(title_layer[2][0])
# title playfield starts with letters palette (sprites) then continues with regular tiles
title_playfield_palette = title_letters_palette + tuple(sorted(set(x for tl in title_layer[0:2] for x in tl[0])))[1:]
title_playfield_palette = title_playfield_palette + (16-len(title_playfield_palette)) * (dummy,)


game_layer = [load_tileset(f"tiles_{i}.png",True,side,used_game_tiles[layer_name],layer_name,dump=dump_it,dumpdir=dumpdir,) for i,layer_name in enumerate(game_layer_names)]

# insert black color to elevator layer
elevators_palette = game_layer[2][0]

elevators_palette.append((0,0,0))
suppressed_elevator_colors = {(37, 117, 117),(255, 176, 218)}
elevators_palette[:] = sorted(set(elevators_palette) - suppressed_elevator_colors)




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

sprites_palette,sprites_set = load_tileset(sprites_1_sheet,True,16,all_sprites,"sprites",dumpdir=dumpdir,dump=dump_it,name_dict=sprite_names)

# dark floor enemies + blue door
sprites_palette_2,sprites_set_2 = load_tileset(sprites_2_sheet,True,16,set(range(16,43,)) | set(range(50,56)) | {0x3E},"sprites",dump=dump_it,
                                            name_dict=sprite_names,tile_offset=64,dumpdir=dumpdir)

sprites_palette_0,sprites_set_0 = load_tileset(sprites_0_sheet,True,16,{1,8,48,47},"sprites",dumpdir=dumpdir,dump=dump_it,name_dict=sprite_names,tile_offset=192)





full_sprite_set = sprites_set + sprites_set_2
full_sprite_set += [None]*(192-len(full_sprite_set)) + sprites_set_0

# playfield+status+sprites
game_playfield_palette = tuple(sorted(set(x for tl in game_layer[0:2] for x in tl[0])))

sprites_palette = sorted(set(sprites_palette) |
  set(sprites_palette_2))

sprites_palette[0] = (0x10,0x20,0x30)  # invalid color, ignored by dual playfield anyway since it's color 0
sprites_palette.insert(1,(0,0,0))

sprites_palette = tuple(sprites_palette)
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
sprites_palette = list(sprites_palette + (16-len(sprites_palette)) * (dummy,))

current_plane_idx = 0

layer_bitmaps = {}

nb_planes = 4

elev_tiles = game_layer[2][1]
# remove inside/outside elevator colors
for c in [0x3A,0x3E,0X3C,0x3F,0x37,0x38,0x3B]:
    bitplanelib.replace_color(elev_tiles[c],suppressed_elevator_colors,(0,0,0))


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

            y_start,ctile = bitplanelib.autocrop_y(tile,mask_color=transparent)
            height = ctile.size[1]

            planes = bitplanelib.palette_image2raw(ctile,None,sprites_palette,forced_nb_planes=nb_planes,
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

src_dir = os.path.join(this_dir,os.pardir,os.pardir,"src","aga")

dark_color_rep = {(255,0,0):(255,0,0), (255,255,255):(111,111,111), (176, 176, 176):(0,111,167)}


dark_palette = [dark_color_rep.get(c,(0,0,0)) for c in game_playfield_palette]

dark_color_rep = {(79,79,79):(0,0,0), (0,0,255):(0,0,176), # enemy skin and blue doors are dark/darker,
 (176, 176, 176):(0,111,167),
 (37,176,176):(0,0,0),
 (0xDA,0xDA,0xDA):(0,0,0),
 (255,255,255):(111,111,111)}  # fake building front sprites follow tiles rules

dark_sprites_palette = [dark_color_rep.get(c,c) for c in sprites_palette]

# dump palettes
with open(os.path.join(src_dir,"palettes.68k"),"w") as f:
    f.write("level_palettes:\n")
    for i in range(4):
        f.write(f"\t.long\tlevel_palette_{i}\n")
    wall_color_index = game_playfield_palette.index(varying_palettes[0][1])
    brick_color_index = game_playfield_palette.index(varying_palettes[0][3])
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

    fake_wall_color_index = sprites_palette.index(varying_palettes[0][1])
    f.write(f"sprite_wall_color_index:\n\t.word\tcolor+{fake_wall_color_index*2}\n")

    f.write("sprite_wall_colors:\n")
    for vp in varying_palettes:
        f.write("\t.word\t0x{:04x}\n".format(bitplanelib.to_rgb4_color(vp[1])))
    f.write("background_purple_color:\n\t.word\t0x{:04x}\n".format(bitplanelib.to_rgb4_color(background_purple_color)))

    f.write(f"dark_palette:\n")
    bitplanelib.palette_dump(dark_palette,f,pformat=bitplanelib.PALETTE_FORMAT_ASMGNU)
    f.write("sprites_palette:\n")
    # introduce white color as last color (BONUS letters, all planes set)
    if sprites_palette[15]==dummy:
        sprites_palette[15] = (0xFF,0xFF,0xFF)
    else:
        raise Exception("Not enough colors to insert last white color")

    # note down the color to change in sprites
    bitplanelib.palette_dump(sprites_palette,f,pformat=bitplanelib.PALETTE_FORMAT_ASMGNU)
    f.write("dark_sprites_palette:\n")
    bitplanelib.palette_dump(dark_sprites_palette,f,pformat=bitplanelib.PALETTE_FORMAT_ASMGNU)
    f.write("title_palette:\n")
    bitplanelib.palette_dump(title_playfield_palette,f,pformat=bitplanelib.PALETTE_FORMAT_ASMGNU)
    f.write("elevators_palette:\n")
    bitplanelib.palette_dump(elevators_palette,f,pformat=bitplanelib.PALETTE_FORMAT_ASMGNU)

    f.write("elevators_dyn_colors:\n")
    for v in varying_palettes_rgb4:
        inside_elevator = v[0]   # dynamic => change to existing gray, change on Y
        outside_elevator = v[2]  # background => change to black, change background on Y
        f.write(f"\t.word\t0x{inside_elevator:04x},0x{outside_elevator:04x}\n")

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



