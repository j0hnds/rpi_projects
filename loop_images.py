#!/usr/bin/env python

import Tkinter as tk
import Image, ImageTk
import glob
import time
import datetime

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
        animatemenu.add_command(label="Today", command=self.start_todays_animation)
        animatemenu.add_command(label="Clear Filter", command=self.clear_filter)

        menubar.add_cascade(label="Animate", menu=animatemenu)

        self.config(menu=menubar)

    def matches_filter(self, path):
        matches = True
        if self.filter is not None:
            matches = path.find(self.filter) >= 0
        return matches

    def next_image_file(self):
        current_path = None
        while current_path is None:
            self.index += 1
            if self.index < len(self.files):
                test_path = self.files[self.index]
                if self.matches_filter(test_path):
                    current_path = test_path
            else:
                break

        return current_path

    def update_image(self):
        image_file = self.next_image_file()
        if image_file is not None and self.continue_animation:

            self.tkimage = self.load_image()
            self.label.configure(image = self.tkimage)

            # call this function again in one second
            self.after(500, self.update_image)

    # Event Handlers

    def clear_filter(self):
        self.filter = None

    def start_todays_animation(self):
        self.index = -1
        self.filter = datetime.date.today().strftime("/%m-%d-%y")
        self.start_animation()

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
    app.title("Webcam Looper")
    app.mainloop()
