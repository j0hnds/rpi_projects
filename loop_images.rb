#!/usr/bin/env ruby

require 'tk'
require 'tkextlib/tkimg'
require 'date'

class SampleApp < TkRoot
  include Tk

  PATH_GLOB = "/home/pi/*.jpg"

  attr_accessor :files, :index, :continue_animation, :label, :filter

  def initialize(options)
    super

    main_menu

    @files = Dir.glob(PATH_GLOB).sort

    @index = 0

    @continue_animation = true

    @filter = nil
    
    tkImage = load_image # TkPhotoImage.new('file' => @files.first)
    @label = TkLabel.new(self) do
      image tkImage
      pack do 
        side 'left' 
      end
    end

  end

  def main_menu
    TkOption.add '*tearOff', 0
    menubar = TkMenu.new(self)

    file_menu menubar
    animate_menu menubar

    self['menu'] = menubar
  end

  def file_menu(menubar)
    file = TkMenu.new(menubar, 'tearoff' => 0)
    menubar.add :cascade, :menu => file, :label => 'File'

    file.add :command, :label => 'Quit', :command => proc { quit }
  end

  def animate_menu(menubar)
    animate = TkMenu.new(menubar, 'tearoff' => 0)
    menubar.add :cascade, :menu => animate, :label => 'Animate'

    animate.add :command, :label => 'Start', :command => proc { start_animation }
    animate.add :command, :label => 'Restart', :command => proc { restart_animation }
    animate.add :command, :label => 'Stop', :command => proc { stop_animation }
    animate.add :command, :label => 'Today', :command => proc { start_todays_animation }
    animate.add :command, :label => 'Clear Filter', :command => proc { clear_filter }
  end
  
  def matches_filter(path)
    matches = true
    matches = path.index(filter) >= 0 unless filter.nil?
    matches
  end

  def next_image_file
    current_path = nil
    while current_path.nil?
      self.index += 1
      if self.index < files.size
        test_path = files[self.index]
        current_path = test_path if matches_filter(test_path)
      else
        break
      end
    end
    current_path
  end

  def update_image
    image_file = next_image_file
    puts "# Displaying image: #{image_file}"
    if !image_file.nil? && continue_animation
      puts "Drawing the image"
      label['image'] = load_image

      Tk.after 500, proc { update_image }
      # after 500, proc { update_image }
    end
  end

  def clear_filter
    filter = nil
  end

  def start_todays_animation
    self.index = -1
    filter = Date.today.strftime("/%m-%d-%y")
    start_animation
  end

  def restart_animation
    self.index = -1
    self.start_animation
  end

  def start_animation
    self.continue_animation = true
    update_image
  end

  def stop_animation
    self.continue_animation = false
  end

  def quit
    destroy # Destroy the root window.
  end

  def load_image
    the_image_file = files[index]
    TkPhotoImage.new('file' => the_image_file )
  end
end

root = SampleApp.new { title "Webcam Looper" }

# Tk.mainloop
root.mainloop
