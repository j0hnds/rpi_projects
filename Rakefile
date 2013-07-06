# -*- ruby -*-

# Define some constants for the version of the packages we're going
# to build
LOOP_IMAGES_VERSION = '1.0.0'
TEMP_HUMIDITY_VERSION = '1.0.0'

UPSTREAM_SOURCES_DIR = 'upstream-sources'

LOOP_IMAGES_UPSTREAM_TARBALL = File.join(UPSTREAM_SOURCES_DIR, "loop-images_#{LOOP_IMAGES_VERSION}.orig.tar.gz")

LOOP_IMAGES_SOURCE_DIR = File.join(UPSTREAM_SOURCES_DIR, "loop-images-#{LOOP_IMAGES_VERSION}")

directory UPSTREAM_SOURCES_DIR

directory LOOP_IMAGES_SOURCE_DIR

# directory File.join(LOOP_IMAGES_SOURCE_DIR, 'debian') do
#   cp_r 'package_source/loop-images/debian', LOOP_IMAGES_SOURCE_DIR
# end

file LOOP_IMAGES_UPSTREAM_TARBALL => [ UPSTREAM_SOURCES_DIR ] do
  system "tar zcf #{LOOP_IMAGES_UPSTREAM_TARBALL} --directory #{UPSTREAM_SOURCES_DIR} loop-images-#{LOOP_IMAGES_VERSION}"

  # Now add the debian files to the 'extracted' source directory
  mkdir File.join(LOOP_IMAGES_SOURCE_DIR, 'debian')
  cp_r 'package_source/loop-images/debian', LOOP_IMAGES_SOURCE_DIR
end

[ 'loop_images.rb' ].each do | source_file |
  file File.join(LOOP_IMAGES_SOURCE_DIR, source_file) => LOOP_IMAGES_SOURCE_DIR do
    cp source_file, LOOP_IMAGES_SOURCE_DIR
  end

  file LOOP_IMAGES_UPSTREAM_TARBALL => File.join(LOOP_IMAGES_SOURCE_DIR, source_file)
end

[ 'loop-images' ].each do | link_file |
  file File.join(LOOP_IMAGES_SOURCE_DIR, link_file) => LOOP_IMAGES_SOURCE_DIR do
    system "cd #{LOOP_IMAGES_SOURCE_DIR}; ln -s #{link_file.gsub('-', '_')}.rb #{link_file}"
  end

  file LOOP_IMAGES_UPSTREAM_TARBALL => File.join(LOOP_IMAGES_SOURCE_DIR, link_file)
end

task :build_loop_images => [ LOOP_IMAGES_UPSTREAM_TARBALL ] do
  # Build the spanky little thing.
  system "cd #{LOOP_IMAGES_SOURCE_DIR}; debuild -us -uc"
end

task :build_upstream_source_tarballs => [ :build_loop_images ]
