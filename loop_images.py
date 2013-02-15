#!/usr/bin/env python

import Tkinter as tk
import Image, ImageTk
import glob
import time

class SampleApp(tk.Tk):
    def __init__(self, *args, **kwargs):
        tk.Tk.__init__(self, *args, **kwargs)

        self.build_menu()

        self.files = sorted(glob.glob("/home/pi/*.jpg"))

        self.index = 0

        self.continue_animation = True

        self.tkimage = self.load_image()
        self.label = tk.Label(self, image=self.tkimage)
        self.label.pack()


    def load_image(self):
        the_image_file = self.files[self.index]
        print the_image_file
        return ImageTk.PhotoImage(Image.open(the_image_file))

    def build_menu(self):
        menubar = tk.Menu(self)

        filemenu = tk.Menu(menubar, tearoff=0)
        filemenu.add_command(label="Quit", command=self.quit)

        menubar.add_cascade(label="File", menu=filemenu)

        animatemenu = tk.Menu(menubar, tearoff=0)
        animatemenu.add_command(label="Start", command=self.start_animation)
        animatemenu.add_command(label="Restart", command=self.restart_animation)
        animatemenu.add_command(label="Stop", command=self.stop_animation)

        menubar.add_cascade(label="Animate", menu=animatemenu)

        self.config(menu=menubar)

    def update_image(self):
        self.index += 1
        if self.index < len(self.files) and self.continue_animation:

            self.tkimage = self.load_image()
            self.label.configure(image = self.tkimage)

            # call this function again in one second
            self.after(500, self.update_image)

    # Event Handlers

    def restart_animation(self):
        self.index = -1
        self.start_animation()

    def start_animation(self):
        self.continue_animation = True
        self.update_image()

    def stop_animation(self):
        self.continue_animation = False
        
if __name__ == "__main__":
    app = SampleApp()
    app.mainloop()
