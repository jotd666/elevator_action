import subprocess,os,glob,shutil

progdir = os.path.abspath(os.path.join(os.path.dirname(__file__),os.pardir))

gamename = "elevator_action"
# JOTD path for cranker, adapt to wh :)
os.environ["PATH"] += os.pathsep+r"K:\progs\cli"

cmd_prefix = ["make","-f",os.path.join(progdir,"makefile.am")]

def make_clean():
    subprocess.check_call(cmd_prefix+["clean"],cwd=os.path.join(progdir,"src"))

make_clean()

subprocess.check_call(cmd_prefix+["RELEASE_BUILD=1"],cwd=os.path.join(progdir,"src"))
# create archive

outdir = os.path.join(progdir,f"{gamename}_HD")

if os.path.exists(outdir):
    for x in glob.glob(os.path.join(outdir,"*")):
        os.remove(x)
else:
    os.mkdir(outdir)
for file in ["readme.md","game_specs.txt",f"{gamename}_aga.slave",f"{gamename}_ocs.slave",f"{gamename}_ecs.slave"]:  #f"{gamename}.slave",
    shutil.copy(os.path.join(progdir,file),outdir)

#shutil.copy(os.path.join(progdir,"assets","amiga","MoonPatrolGlowIcon.info"),outdir)


for suffix in ["ocs","ecs","aga"]:
    # pack the file for floppy
    exename = f"{gamename}_{suffix}"
    shutil.copy(os.path.join(progdir,exename),outdir)
    subprocess.check_output(["cranker_windows.exe","-f",os.path.join(progdir,exename),"-o",os.path.join(progdir,f"{exename}.rnc")])

make_clean()