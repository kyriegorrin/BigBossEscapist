from pynput.keyboard import Key, Controller, Listener
from pynput import mouse
from time import sleep
import subprocess as sp
import os, signal

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
#p1 = sp.call(["top"], shell=True)
p1 = sp.Popen(["gnome-terminal", "--command=top"])
sleep(0.5)
os.system("python ~/.scripts/move_window.py small_right")
sleep(0.2)

#pid2 = sp.call(["gnome-terminal", "-e", "vim SPerMA_bench.sh"])
p2 = sp.Popen(["gnome-terminal", "--command=vi SPerMA_bench.sh"])
sleep(0.5)
os.system("python ~/.scripts/move_window.py big_left")
sleep(0.2)
keyboard.type("i")


#Open bullshit template
fd = open("stud.sh", "r")

#TODO: ADD LISTENER TO END THE PROGRAM
def on_press(key):
    if key == Key.esc:
        #os.kill(pid1, signal.SIGTERM)        
        #os.kill(pid2, signal.SIGTERM)        
        exit()
''' LISTENER RIPERINO
Listener(on_press=on_press) 
'''

'''
#Live the dream
for line in fd:
   typeLine(line)
'''


#We nuke all processes. It's done like this because there are 
#subprocesses created from the gnome-terminal we can't reach.
sp.call(["killall", "top"])
sp.call(["killall", "vi"])