#!/usr/bin/env ruby

require 'tk'
require 'tkextlib/tkimg'
require 'date'

class SampleApp < TkRoot
  include Tk

  PATH_GLOB = "/home/pi/Pictures/webcam/*.jpg"

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
    menubar.add :cascade, :menu => file, :label => 'File', :underline => 0

    file.add :command, :label => 'Quit', :underline => 0, :accelerator => 'Ctrl+Q', :command => proc { quit }

    bind "Control-q", proc { quit }
  end

  def animate_menu(menubar)
    animate = TkMenu.new(menubar, 'tearoff' => 0)
    menubar.add :cascade, :menu => animate, :label => 'Animate', :underline => 0

    animate.add :command, :label => 'Start', :underline => 0, :command => proc { start_animation }
    animate.add :command, :label => 'Restart', :underline => 0, :command => proc { restart_animation }
    animate.add :command, :label => 'Stop', :underline => 1, :command => proc { stop_animation }
    
    animate_from = TkMenu.new(animate, 'tearoff' => 0)
    animate.add :cascade, :menu => animate_from, :label => 'Animate From', :underline => 0

    animate_from.add :command, :label => 'Today', :underline => 0, :accelerator => 'Ctrl-T', :command => proc { start_animation_from 0 }
    bind "Control-t", proc { start_animation_from 0 }
    animate_from.add :command, :label => 'Yesterday', :underline => 0, :accelerator => 'Ctrl-Y', :command => proc { start_animation_from 1 }
    bind "Control-y", proc { start_animation_from 1 }
    animate_from.add :command, :label => '2 days ago', :underline => 0, :command => proc { start_animation_from 2 }
    animate_from.add :command, :label => '3 days ago', :underline => 0, :command => proc { start_animation_from 3 }
    animate_from.add :command, :label => '4 days ago', :underline => 0, :command => proc { start_animation_from 4 }
    animate_from.add :command, :label => '5 days ago', :underline => 0, :command => proc { start_animation_from 5 }
    animate_from.add :command, :label => '6 days ago', :underline => 0, :command => proc { start_animation_from 6 }
    animate_from.add :command, :label => '7 days ago', :underline => 0, :command => proc { start_animation_from 7 }
    
    animate.add :command, :label => 'Clear Filter', :underline => 0, :command => proc { clear_filter }
  end
  
  def matches_filter(path)
    matches = true
    matches = !path.index(filter).nil? unless filter.nil?
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

  #
  # Event Handlers
  #

  def clear_filter
    self.filter = nil
  end

  def start_animation_from(days_back)
    self.index = -1
    self.filter = (Date.today - days_back).strftime("/%m-%d-%y")
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

  private

  def load_image
    the_image_file = files[index]
    TkPhotoImage.new('file' => the_image_file )
  end

  def update_image
    image_file = next_image_file
    if !image_file.nil? && continue_animation
      new_image = load_image
      label['image'].copy new_image, :zoom => [ 2, 2 ]
      new_image = nil

      Tk.after 500, proc { update_image }
    end
  end

end

root = SampleApp.new { title "Webcam Looper" }

root.mainloop
