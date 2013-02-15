#!/usr/bin/env python

import Tkinter as tk
import Image, ImageTk
import glob
import time

class SampleApp(tk.Tk):
    def __init__(self, *args, **kwargs):
        tk.Tk.__init__(self, *args, **kwargs)
        self.files = sorted(glob.glob("/home/pi/*.jpg"))

        self.index = 0

        first_file = self.files[0]

        print first_file

        self.img = Image.open(first_file)
        self.tkimage = ImageTk.PhotoImage(self.img)
        self.label = tk.Label(self, image=self.tkimage)
        self.label.pack()
        self.after(500, self.update_image)

    def update_image(self):
        self.index += 1
        if self.index < len(self.files):
            the_file = self.files[self.index]
            print the_file

            self.img = Image.open(self.files[self.index])
            self.tkimage = ImageTk.PhotoImage(self.img)
            self.label.configure(image = self.tkimage)

            # call this function again in one second
            self.after(500, self.update_image)

        
if __name__ == "__main__":
    app = SampleApp()
    app.mainloop()
