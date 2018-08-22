#!/usr/bin/python

import sys

v=sys.version

if "2.7" in v:
    from Tkinter import *
elif "3.3" in v or "3.4" in v:
    from tkinter import *

class App:
    def __init__(self, master):
        frame = Frame(master)
        frame.pack()

        self.button = Button(frame, text="Quit", fg="red", command=frame.quit)
        self.button.pack(side=LEFT)

        self.hi_there = Button(frame, text="Hello!", command=self.say_hi)
        self.hi_there.pack(side=LEFT)

    def say_hi(self):
        print "hi there!"

root = Tk()

app = App(root)

root.mainloop()
root.destroy()
