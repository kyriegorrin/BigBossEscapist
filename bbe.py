from pynput.keyboard import Key, Controller
from pynput import mouse
from time import sleep

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

keyboard.press('p')
keyboard.release('p')

keyboard.type('Hakuna matata')

mouseController.position = (10, 20)
mouseController.move(50, 50)
dragMouse(300, 300)