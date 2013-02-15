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

        self.tkimage = self.load_image()
        self.label = tk.Label(self, image=self.tkimage)
        self.label.pack()
        self.after(500, self.update_image)

    def load_image(self):
        the_image_file = self.files[self.index]
        print the_image_file
        return ImageTk.PhotoImage(Image.open(the_image_file))

    def update_image(self):
        self.index += 1
        if self.index < len(self.files):

            self.tkimage = self.load_image()
            self.label.configure(image = self.tkimage)

            # call this function again in one second
            self.after(500, self.update_image)

        
if __name__ == "__main__":
    app = SampleApp()
    app.mainloop()
