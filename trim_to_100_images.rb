#!/usr/bin/env ruby

PATH_TO_IMAGES = File.join(ENV['HOME'], 'Pictures/webcam')
NUM_FILES_TO_KEEP = 100

files = Dir[File.join(PATH_TO_IMAGES, '*')].sort

number_of_files = files.size

exit 0 if number_of_files <= NUM_FILES_TO_KEEP

number_of_files_to_delete = number_of_files - NUM_FILES_TO_KEEP

files_to_delete = files[0...number_of_files_to_delete]

files_to_delete.each { | file_to_delete | File.unlink file_to_delete }
