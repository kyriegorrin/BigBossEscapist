from pynput.keyboard import Key, Controller
from pynput import mouse
from time import sleep
import subprocess as sp
import os

#Input controllers
keyboard = Controller()
mouseController = mouse.Controller()

#Helper functions
def dragMouse(dx, dy):
    for i in range(0, dx):
        if dx > 0:
            mouseController.move(1, 0)
        else:
            mouseController.move(-1, 0)
        sleep(0.001)

    for i in range(0, dy):
        if dy > 0:
            mouseController.move(0, 1)
        else:
            mouseController.move(0, -1)
        sleep(0.001)

def typeLine(line):
    count = 0
    for character in line:
        keyboard.type(character)
        sleep(0.1)
        count += 1
        #Add some more human-like typing
        if count % 20 == 0:
            sleep(1)

#mouseController.position = (10, 20)
#mouseController.move(50, 50)
#dragMouse(300, 300)

#Create and move terminals, sleep to ensure enough time to boot shells
os.system("gnome-terminal -e 'top'")
sleep(0.5)
os.system("python ~/.scripts/move_window.py small_right")
sleep(0.2)

os.system("gnome-terminal -e 'vim SPerMA_bench.sh'")
sleep(0.5)
os.system("python ~/.scripts/move_window.py big_left")
sleep(0.2)
keyboard.type("i")

#TODO: ADD LISTENER TO END THE PROGRAM

#Open bullshit template and live the dream
fd = open("stud.sh", "r")
for line in fd:
   typeLine(line)

#pid2 = sp.Popen(args=["gnome-terminal", "--vim totallySeriousCode.sh"]).pid
#pid2 = sp.Popen(args=["gnome-terminal", "-e", "'bash'"]).pid
#sleep(1)
#keyboard.type("\n")
#keyboard.type("python ~/.scripts/move_window.py big_left \n")
#sp.call(["python", "~/.scripts/move_window.py", "big_left"])
#keyboard.type("i Hola titus")
#print "Vim terminal spawned, pid: ", pid2