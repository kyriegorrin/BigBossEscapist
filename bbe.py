from pynput.keyboard import Key, Controller
from pynput import mouse
from time import sleep
import subprocess as sp
import os

keyboard = Controller()
mouseController = mouse.Controller()

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

#keyboard.press('p')
#keyboard.release('p')
#
#keyboard.type('Hakuna matata')
#
#mouseController.position = (10, 20)
#mouseController.move(50, 50)
#dragMouse(300, 300)

#Getting our HOME and move_window variable
home = os.environ["HOME"]
move_window = home + "move_window.py"

#Create and move terminals, sleep to ensure enough time to boot shells
os.system("gnome-terminal -e 'top'")
sleep(0.5)
os.system("python ~/.scripts/move_window.py small_right")
sleep(0.2)

os.system("gnome-terminal -e 'vim SPerMA_bench.sh'")
sleep(0.5)
os.system("python ~/.scripts/move_window.py big_left")
sleep(0.2)

#pid2 = sp.Popen(args=["gnome-terminal", "--vim totallySeriousCode.sh"]).pid
#pid2 = sp.Popen(args=["gnome-terminal", "-e", "'bash'"]).pid
#sleep(1)
#keyboard.type("\n")
#keyboard.type("python ~/.scripts/move_window.py big_left \n")
#sp.call(["python", "~/.scripts/move_window.py", "big_left"])
#keyboard.type("i Hola titus")
#print "Vim terminal spawned, pid: ", pid2