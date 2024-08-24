import os,struct,re

# save log like S log $100 $4000
with open(r"C:\Users\Public\Documents\Amiga Files\WinUAE\log","rb") as f:
    contents = f.read()

pcs = set()
# generated using LOG_REGS
"""
    .macro    LOG_REGS    z80pc
    move.w    sr,-(a7)
    move.l    a6,-(a7)
    move.l    log_ptr,a6
    move.w    #\z80pc,(a6)+
    move.b    d0,(a6)+
    move.b    d1,(a6)+
    move.b    d2,(a6)+
    move.b    d3,(a6)+
    move.b    d4,(a6)+
    move.b    d5,(a6)+
    move.b    d6,(a6)+
    move.b    d7,(a6)+
    move.b    ixh,(a6)+
    move.b    ixl,(a6)+
    move.w    #0xDEAD,(a6)+
    move.l    a6,log_ptr
    move.l    (a7)+,a6
    move.w    (a7)+,sr
    .endm
"""

len_block = 18

sorted_cmp = False
avoid_regs = ["iy"]
regslist = list("abcdehl")+["ix","iy","hl"]


def rework(name):
    if regs[name]<0 or regs[name]>=0x8000:
        regs[name]=0xFFFF  # invalid (points to ROM?)
    else:
        regs[name]+=0x8000

lst = []
for i in range(0,len(contents),len_block):
    chunk = contents[i:i+len_block]
    if len(chunk)<len_block:
        break
    regs=dict()
    regs["pc"],regs["a"],regs["b"],regs["c"],regs["d"],regs["e"],regs["h"],regs["l"],regs["d7"],regs["hl"],regs["ix"],regs["iy"],end = struct.unpack_from(">HBBBBBBBBHHHH",chunk)
    if end==0xCCCC:
        break
    pcs.add(regs["pc"])

    rework("hl")
    rework("ix")
    rework("iy")





    regstr = ["{}={:02X}".format(reg.upper(),regs[reg]) for reg in regslist if reg not in avoid_regs]
    rest = ", ".join(regstr)

    out = f"{regs['pc']:04X}: {rest}\n"

    lst.append(out)

if sorted_cmp:
    lst.sort()

with open("amiga.tr","w") as f:
    f.writelines(lst)

# generated using log:     trace mame.tr,,,{tracelog "A=%02X, B=%02X, C=%02X, D=%02X, E=%02X, H=%02X, L=%02X, IX=%04X, IY=%04X ",a,b,c,d,e,h,l,ix,iy}
lst = []
print("reading MAME trace file...")
with open(r"K:\Emulation\MAME\mame.tr","r") as f:
    l = len("A=01, B=00, C=3F, D=93, E=81, H=93, L=01, IX=XXXX, IY=XXXX ")
    for line in f:
        m = re.match("A=(..), B=(..), C=(..), D=(..), E=(..), H=(..), L=(..), IX=(....), IY=(....)",line)
        if m:
            pc = line[l:l+4]
            regs = dict()
            if int(pc,16) in pcs:
                regs["a"],regs["b"],regs["c"],regs["d"],regs["e"],regs["h"],regs["l"],regs["ix"],regs["iy"] = m.groups()
                regs["hl"] = "{:04X}".format((int(regs["h"],16)<<8)+int(regs["l"],16))
                regstr = ["{}={}".format(reg.upper(),regs[reg]) for reg in regslist if reg not in avoid_regs]
                rest = ", ".join(regstr)
                lst.append(f"{pc}: {rest}\n")

if sorted_cmp:
    lst.sort()
print("writing filtered MAME trace file...")
with open("mame.tr","w") as fw:
    fw.writelines(lst)
