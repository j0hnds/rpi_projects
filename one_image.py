#!/usr/bin/env python
import Tkinter as tk
import Image, ImageTk
import glob

files = sorted(glob.glob("/home/pi/*.jpg"))

# open a SPIDER image and convert to byte format
im = Image.open(files[0])

root = tk.Tk()  # A root window for displaying objects

 # Convert the Image object into a TkPhoto object
tkimage = ImageTk.PhotoImage(im)

tk.Label(root, image=tkimage).pack() # Put it in the display window

root.mainloop() # Start the GUI
