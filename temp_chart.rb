#!/usr/bin/env ruby

require 'tk'
require 'tkextlib/tkimg'

class TempChartApp < TkRoot
  include Tk

  attr_reader :label

  def initialize(options)
    super
    
    main_menu

    tkImage = load_image
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

    chart_menu menubar

    self['menu'] = menubar
  end

  def file_menu(menubar)
    file = TkMenu.new(menubar, 'tearoff' => 0)
    menubar.add :cascade, :menu => file, :label => 'File', :underline => 0

    file.add :command, :label => 'Quit', :underline => 0, :accelerator => 'Ctrl+Q', :command => proc { quit }

    bind "Control-q", proc { quit }
  end

  def chart_menu(menubar)
    chart = TkMenu.new(menubar, 'tearoff' => 0)
    menubar.add :cascade, :menu => chart, :label => 'Chart', :underline => 0

    chart.add :command, :label => 'Create', :underline => 0, :command => proc { create_chart }
  end

  def quit
    destroy # Destroy the root window.
  end

  def create_chart
    puts "Creating chart..."
    base_dir = File.dirname(__FILE__)
    system "#{base_dir}/chart_temp_humidity.sh"
    puts "Chart created, loading..."
    new_image = load_image
    label['image'].copy new_image
    new_image = nil
  end

  def load_image
    TkPhotoImage.new('file' => File.join('/tmp', 'temp_humidity.gif'))
  end

end

root = TempChartApp.new { title "Temperature Chart Display" }

root.mainloop

