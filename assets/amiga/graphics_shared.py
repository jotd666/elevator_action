from PIL import Image,ImageOps
import os,sys,bitplanelib

this_dir = os.path.dirname(os.path.abspath(__file__))

background_purple_color = (0xB0,0x8A,0xFF)

varying_palettes = [
# level 1
((255,176,218),  # pink, inside elevator
(0x25,0xB0,0xB0),  # blue, walls
(0X25,0x75,0x75),  # elevator background (around wire)
(0xFF,0,0)         # brick color (red)
),
# level 2
((0xB0,0xFF,0xFF),  # cyan, inside elevator
(0xDA,0x8A,0xDA),   # pink, walls
(0xFF,0xDA,0xFF),  # light pink, elevator background
(0xFF,0xFF,0x8A),  # brick color (yellowish)
),
# level 3
((0xFF,0x8A,0xB0),  # pink, inside elevator
(0xDA,0xFF,0xFF),   # light gray, walls
(0,0xB0,0xDA),     # light blue, elevator background
(0xFF,0,0)         # brick color (red)
),
# level 4
((0x25,0xDA,0xDA),  # blue, inside elevator
(0x8A,0x8A,0x8A),   # dark gray, walls
(1,1,1),  # black, elevator background
(0xB0,0xFF,0)         # brick color (greenish)
)
]



sprite_names = dict()

side = 8
transparent = (254,0,254)  # not possible to get it in the game
dummy = (1,1,1)  # not possible to get it in the game

def dump_asm_bytes(*args,**kwargs):
    bitplanelib.dump_asm_bytes(*args,**kwargs,mit_format=True)


varying_palettes_rgb4 = [
[bitplanelib.to_rgb4_color(x) for x in lst] for lst in varying_palettes]



def ensure_empty(d):
    if os.path.exists(d):
        for f in os.listdir(d):
            os.remove(os.path.join(d,f))
    else:
        os.makedirs(d)

def load_tileset(image_name,game_gfx,side,used_tiles,tileset_name,dumpdir,dump=False,name_dict=None,tile_offset=0):
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
        if tile_offset == 0:
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

                # quick hack: inside the document briefcase is transparent, shuold be black
                # there are just 2 frames, so instead of doing all the crap I did for black enemies
                # let's just change it manually
                if tile_offset==192:
                    if tile_number==8:
                        paint_black(img,((9,7),(9,8),(11,8),(12,8),(13,8),(13,7)))
                    elif tile_number==0x30:
                        paint_black(img,((8,7),(8,8),(9,8),(11,8),(12,8),(12,7)))


                tileset_1.append(img)
                if dump:
                    img = ImageOps.scale(img,5,resample=Image.Resampling.NEAREST)
                    if name_dict:
                        name = name_dict.get(tile_number+tile_offset,"unknown")
                    else:
                        name = "unknown"

                    img.save(os.path.join(dump_subdir,f"{name}_{tile_number+tile_offset:02x}.png"))

            tile_number += 1

    return sorted(set(palette)),tileset_1

# for each layer, very few tiles are used. Don't generate all tiles with the given colors,
# just the ones that are used
# lists below may be incomplete

 # BONUS + big digits, but displayed above other layer, end up be displayed on sprites layer
 # note 'U', 'S' and rotating '0' on palette 0 is dynamic in the game. Fortunately,
 # color 0 is used fot "status" layer ("U","S" letters) for tiles E0,E1,...
 # and color 1 is used for "building" layer (floor marks for doors & stairs)
used_game_tiles = {"status":set(range(16,52)) | {1,0x4E} | set(range(0xC6,0x100)),
  "building": set(range(0x40,0xC0)) | set(range(0xE0,0xED))
   | {148,
  197,
  0x98,0x99,0x9A,0x9B,0x9C,0xFD,0xFE,  # grappling hook
  0x81,0x8C,0x88,0x89,0x85,0x8A,0x8B,
  0x90,0x91,0x93,0x34,0x35,0x36,0x28,0x29,0x24,0x26,0x6,0xC4,0xA0
  },"elevators":{252, 55, 56, 58, 59, 60, 61, 62, 63}}

used_title_tiles = {"status":set(range(16,50)) | {4,5,6,7,8,51},
"big_letters": set(range(80,128)) | {64,0x4B,0x4C,0x4D,0x4E,0x4F,0x94} | set(range(158,256)),
"elevator_letters": set(range(128,181)) | {248, 249}}

game_layer_names = ["status","building","elevators"]
title_layer_names = ["status","big_letters","elevator_letters"]

tile_bitplane_cache = dict()

tile_palettes = []
game_palettes = []


def paint_black(img,coords):
    for x,y in coords:
        img.putpixel((x,y),(0,0,0))

def change_color(img,color1,color2):
    rval = Image.new("RGB",img.size)
    for x in range(img.size[0]):
        for y in range(img.size[1]):
            p = img.getpixel((x,y))
            if p==color1:
                p = color2
            rval.putpixel((x,y),p)
    return rval

def add_sprite(index,name):
    sprite_names[index] = name

def add_sprite_range(start,end,name):
    for i in range(start,end):
        sprite_names[i] = name

# better name sprites, as some color hacks are needed (black color is used for spies and lamps)
add_sprite_range(0,16,"player")
add_sprite_range(16,32,"enemy")
add_sprite_range(32,40,"red_door")
add_sprite_range(43,48,"car")
add_sprite_range(48,50,"player_shoots")
add_sprite_range(50,56,"enemy_shoots")
add_sprite_range(56,58,"shot")
add_sprite_range(58,61,"player")
add_sprite_range(61,62,"exclamation")
add_sprite(63,"lamp_exploding")
#add_sprite_range(0x28,0x2B,"wall")  # to be draw above characters on stairs

# sprites have more "cluts" but it's relying on palette sometimes and also isn't worth
# implementing, as for instance, player sprite or car only have one valid clut.
# enemies and doors have different color schemes. 3 color schemes for enemies, 2 color schemes for doors
#
# add 2 special enemy "cluts" and blue opening door
add_sprite_range(16+64,32+64,"enemy_dark_floor")
add_sprite_range(50+64,56+64,"enemy_dark_floor_shoots")
add_sprite_range(32+64,40+64,"blue_door")
add_sprite(64+0x3E,"lamp")  # falling lamp
add_sprite_range(0x28+64,0x2B+64,"wall")  # to be draw above characters on stairs

add_sprite(1+192,"five_hundred_points")
add_sprite(8+192,"player_carrying_file")
add_sprite(47+192,"five_hundred_points")
add_sprite(48+192,"player_carrying_file")


sprites_path = os.path.join(this_dir,os.path.pardir,"elevator","game")
sprites_1_sheet = Image.open(os.path.join(sprites_path,"sprites_1.png"))  # player, red door, enemies
sprites_2_sheet = Image.open(os.path.join(sprites_path,"sprites_2.png"))  # blue door, covering walls
sprites_0_sheet = Image.open(os.path.join(sprites_path,"sprites_0.png"))  # misc (player with documents)
