import subprocess,os,struct,glob,tempfile
import shutil

import config
gamename = config.gamename
sox = "sox"

if not shutil.which("sox"):
    raise Exception("sox command not in path, please install it")
# BTW convert wav to mp3: ffmpeg -i input.wav -codec:a libmp3lame -b:a 330k output.mp3

#wav_files = glob.glob("sounds/*.wav")

this_dir = os.path.dirname(__file__)
sound_dir = os.path.join(this_dir,"..","sounds")

this_dir = os.path.dirname(__file__)
src_dir = os.path.join(this_dir,"../../src/aga")
outfile = os.path.join(src_dir,"sounds.68k")
sndfile = os.path.join(src_dir,"sound_entries.68k")

hq_sample_rate = 18004
lq_sample_rate = hq_sample_rate//2
vhq_sample_rate = 22030

loop_channel = 3

EMPTY_SND = "EMPTY_SND"
sound_dict = {


"FORGOT_DOCUMENTS_SND"               :{"index":0,"channel":0,"sample_rate":hq_sample_rate,"priority":5},
"CREDIT_SND"               :{"index":1,"channel":0,"sample_rate":hq_sample_rate},
"WALK_SND"                 :{"index":2,"channel":2,"sample_rate":hq_sample_rate,"priority":2},
"HOOK_SHOT_SND"                :{"index":3,"pattern":0,"volume":20,'loops':True},
"DOCUMENT_COLLECTED_SND"                :{"index":4,"channel":2,"sample_rate":hq_sample_rate,"priority":20},
"RED_DOOR_OPENED_SND"                :{"index":5,"channel":3,"sample_rate":hq_sample_rate,"priority":5},
"DOWN_THE_STAIRS_SND"                :{"index":6,"channel":2,"sample_rate":hq_sample_rate,"priority":5},
"UP_THE_STAIRS_SND"                :{"index":7,"channel":2,"sample_rate":hq_sample_rate,"priority":5},
"KICKING_ENEMY_SND"                :{"index":8,"channel":2,"sample_rate":hq_sample_rate,"priority":5},
"HURRY_UP_SND"                :{"index":9,"pattern":12,"volume":25,'loops':False, "ticks":-1},  # not zero but music is not interruptible
"JUMPING_SND"                :{"index":10,"channel":2,"sample_rate":hq_sample_rate,"priority":10},
"BULLET_HITS_WALL_SND"                :{"index":11,"channel":2,"sample_rate":hq_sample_rate,"priority":1},
"KICKING_ENEMY_SND"                :{"index":12,"channel":1,"sample_rate":hq_sample_rate,"priority":20},
"LAMP_FALLS_SND"                :{"index":13,"channel":2,"sample_rate":hq_sample_rate,"priority":5},
"PLAYER_SHOT_SND"                :{"index":14,"channel":3,"sample_rate":hq_sample_rate,"priority":10},
"ENEMY_SHOT_SND"                :{"index":15,"channel":2,"sample_rate":hq_sample_rate,"priority":2},
"PLAYER_FALLS_SND"                :{"index":16,"channel":1,"sample_rate":hq_sample_rate,"priority":5},
"PLAYER_KILLED_SND"                :{"index":17,"channel":1,"sample_rate":hq_sample_rate,"priority":20},
"PLAYER_CRUSHED_SND"               :{"index":18,"channel":1,"sample_rate":hq_sample_rate,"priority":5},
"RETURN_TO_DOOR_SND"               :{"index":19,"channel":loop_channel,"sample_rate":hq_sample_rate,"priority":5,"loops":True},
"PLAYER_CRUSHED_2_SND"               :{"index":20,"channel":1,"sample_rate":hq_sample_rate,"priority":1},
"ENEMY_KILLED_SND"               :{"index":21,"channel":2,"sample_rate":hq_sample_rate,"priority":10},
"ELEVATOR_LOOP_SND"               :{"index":22,"channel":loop_channel,"sample_rate":hq_sample_rate,"priority":10,"loops":True},
"ELEVATOR_STOPS_SND"               :{"index":23,"channel":loop_channel,"sample_rate":hq_sample_rate,"priority":10},
"CAR_EXIT_SND"               :{"index":24,"channel":0,"sample_rate":hq_sample_rate,"priority":10},
"EXTRA_LIFE_SND"               :{"index":25,"channel":1,"sample_rate":hq_sample_rate,"priority":20},
"MAIN_THEME_SND"                :{"index":26,"pattern":3,"volume":13,'loops':True},
"HURRY_UP_THEME_SND"                :{"index":27,"pattern":9,"volume":13,'loops':True},
"GAME_OVER_SND"                :{"index":28,"pattern":10,"volume":25,'loops':False, "ticks":150},
#"PING_SND"                :{"index":9,"channel":2,"sample_rate":hq_sample_rate,"priority":20},  not sure when or why it's played...


}

with open(os.path.join(src_dir,"..","sounds.inc"),"w") as f:
    for k,v in sorted(sound_dict.items(),key = lambda x:x[1]["index"]):
        f.write(f"\t.equ\t{k},  0x{v['index']:x}\n")

max_sound = 0x20  # max(x["index"] for x in sound_dict.values())+1
sound_table = [""]*max_sound
sound_table_set_1 = ["\t.long\t0,0"]*max_sound




snd_header = rf"""
# sound tables
#
# the "sound_table" table has 8 bytes per entry
# first word: 0: no entry, 1: sample, 2: pattern from music module
# second word: 0 except for music module: pattern number
# longword: sample data pointer if sample, 0 if no entry and
# 2 words: 0/1 noloop/loop followed by duration in ticks
#
FXFREQBASE = 3579564

    .macro    SOUND_ENTRY    sound_name,size,channel,soundfreq,volume,priority
\sound_name\()_sound:
    .long    \sound_name\()_raw
    .word   \size
    .word   FXFREQBASE/\soundfreq,\volume
    .byte    \channel
    .byte    \priority
    .endm

"""

def write_asm(contents,fw):
    n=0
    for c in contents:
        if n%16 == 0:
            fw.write("\n\t.byte\t0x{:x}".format(c))
        else:
            fw.write(",0x{:x}".format(c))
        n += 1
    fw.write("\n")

music_module_label = f"{gamename}_tunes"

raw_file = os.path.join(tempfile.gettempdir(),"out.raw")
with open(sndfile,"w") as fst,open(outfile,"w") as fw:
    fst.write(snd_header)

    fw.write("\t.section\t.datachip\n")
    fw.write("\t.global\t{}\n".format(music_module_label))

    for wav_file,details in sound_dict.items():
        wav_name = os.path.basename(wav_file).lower()[:-4]
        if details.get("channel") is not None:
            fw.write("\t.global\t{}_raw\n".format(wav_name))


    for wav_entry,details in sound_dict.items():
        sound_index = details["index"]

        channel = details.get("channel")
        if channel is None:
            # if music loops, ticks are set to 1 so sound orders only can happen once (else music is started 50 times per second!!)

            sound_table_set_1[sound_index] = "\t.word\t{},{},{}\n\t.byte\t{},{}".format(2,details["pattern"]+1,details.get("ticks",0),details["volume"],int(details["loops"]))
        else:
            wav_name = os.path.basename(wav_entry).lower()[:-4]
            wav_file = os.path.join(sound_dir,wav_name+".wav")

            def get_sox_cmd(sr,output):
                return [sox,"--volume","1.0",wav_file,"--channels","1","-D","--bits","8","-r",str(sr),"--encoding","signed-integer",output]


            used_sampling_rate = details["sample_rate"]
            used_priority = details.get("priority",1)

            cmd = get_sox_cmd(used_sampling_rate,raw_file)

            subprocess.check_call(cmd)
            with open(raw_file,"rb") as f:
                contents = f.read()

            # compute max amplitude so we can feed the sound chip with an amped sound sample
            # and reduce the replay volume. this gives better sound quality than replaying at max volume
            # (thanks no9 for the tip!)
            signed_data = [x if x < 128 else x-256 for x in contents]
            maxsigned = max(signed_data)
            minsigned = min(signed_data)

            amp_ratio = max(maxsigned,abs(minsigned))/32
            wav = os.path.splitext(wav_name)[0]
            if amp_ratio > 1:
                print(f"{wav}: volume peaked {amp_ratio}")
                amp_ratio = 1
            sound_table[sound_index] = "    SOUND_ENTRY {},{},{},{},{},{}\n".format(wav,len(signed_data)//2,channel,used_sampling_rate,int(64*amp_ratio),used_priority)
            sound_table_set_1[sound_index] = f"\t.word\t1,{int(details.get('loops',0))}\n\t.long\t{wav}_sound"

            if amp_ratio > 0:
                maxed_contents = [int(x/amp_ratio) for x in signed_data]
            else:
                maxed_contents = signed_data

            signed_contents = bytes([x if x >= 0 else 256+x for x in maxed_contents])
            # pre-pad with 0W, used by ptplayer for idling
            if signed_contents[0] != b'\x00' and signed_contents[1] != b'\x00':
                # add zeroes
                signed_contents = struct.pack(">H",0) + signed_contents

            contents = signed_contents
            # align on 16-bit
            if len(contents)%2:
                contents += b'\x00'
            # pre-pad with 0W, used by ptplayer for idling
            if contents[0] != b'\x00' and contents[1] != b'\x00':
                # add zeroes
                contents = b'\x00\x00' + contents

            fw.write("{}_raw:   | {} bytes".format(wav,len(contents)))

            if len(contents)>65530:
                raise Exception(f"Sound {wav_entry} is too long")
            write_asm(contents,fw)

    # make sure next section will be aligned
    with open(os.path.join(sound_dir,f"{gamename}_conv.mod"),"rb") as f:
        contents = f.read()
    fw.write("{}:".format(music_module_label))
    write_asm(contents,fw)
    fw.write("\t.align\t8\n")


    fst.writelines(sound_table)
    fst.write("\n\t.global\t{0}\n\n{0}:\n".format("sound_table"))
    for i,st in enumerate(sound_table_set_1):
        fst.write(st)
        fst.write(" | {}\n\n".format(i))




