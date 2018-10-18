from pynput.keyboard import Key, Controller, Listener
from pynput import mouse
from time import sleep
import subprocess as sp
import os, signal

##########Variables and controllers############

#Input controllers
keyboard = Controller()
mouseController = mouse.Controller()

#Drag variables
dragX = 500
dragY = 500

#Exit variable
finished = False

###########Helper functions############

#Function that drags the mouse
def dragMouse(dx, dy):
    if dx > 0:
        for i in range(0, dx):
            mouseController.move(1, 0)
            sleep(0.001)
    else:
        for i in range (0, dx, -1):
            mouseController.move(-1, 0)
            sleep(0.001)

    if dy > 0:
        for i in range(0, dy):
            mouseController.move(0, 1)
            sleep(0.001)
    else:
        for i in range (0, dy, -1):
            mouseController.move(0, -1)
            sleep(0.001)


#Function that "types" a string
def typeLine(line):
    count = 0
    for character in line:
        #If program terminated, exit
        if finished:
            #Clear junk generated
            os.system("rm " + os.environ["PWD"] + "/.SPerMA_bench.*")
            exit()
        keyboard.type(character)
        sleep(0.1)
        count += 1
        #Add some more human-like typing
        if count % 20 == 0:
            sleep(1)

#Function for the user input listener
def on_press(key):
    if key == Key.esc:
        #We nuke all top and vi processes. It's done like this because there are 
        #subprocesses created from the gnome-terminal we can't reach (unknown pid).
        sp.call(["killall", "top"])
        sp.call(["killall", "vi"])

        #Access thread variable
        global finished 
        finished = True
        exit()

#############Script##############

#Create and move terminals, sleep to ensure enough time to boot shells
p1 = sp.Popen(["gnome-terminal", "--command=top"])
sleep(0.5)
os.system("python ~/.scripts/move_window.py small_right")

p2 = sp.Popen(["gnome-terminal", "--command=vi SPerMA_bench.sh"])
sleep(0.5)
os.system("python ~/.scripts/move_window.py big_left")
keyboard.type("i")

#Open bullshit template
fd = open("stud.sh", "r")

#Create a listener thread
listener = Listener(on_press=on_press)
listener.start()

#Live the dream
for line in fd:
   typeLine(line)

   #TODO: fix mouse usage
   #dragMouse(700, 700)
   #dragX = -dragX
   #dragY = -dragY