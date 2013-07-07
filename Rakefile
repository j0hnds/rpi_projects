# -*- ruby -*-
require 'yaml'

PACKAGE_CONSTRUCTION_DIR = 'package-construction'

directory PACKAGE_CONSTRUCTION_DIR

desc "Remove the package construction directory"
task :clean_packages do
  rm_rf PACKAGE_CONSTRUCTION_DIR
end

desc "Build all the configured debian packages for this project"
task :build_deb_packages => [ :load_package_configurations, :deb_packages ]

task :deb_packages

task :load_package_configurations do
  Dir.glob('config/*.yml').each do | config_path |
    File.open(config_path) do | f |
      config = YAML.load(f)
      build_package_tasks config
    end
  end
end

#
# Given the configuration entry for a package, create all the necessary
# rake tasks, files and directories to build the package. 
#
def build_package_tasks(config)
  # The name of the task to build the package
  package_task_name = "build_#{config[:package_name]}"

  # Add task name to the list of dependencies for the :deb_packages task
  task :deb_packages => package_task_name

  # The path to the package source directory
  pkg_src_dir = File.join(PACKAGE_CONSTRUCTION_DIR, source_dir_name(config))

  # Directory task to ensure the existence of the directory
  directory pkg_src_dir

  # Create the tarball task
  orig_source_tarball_path = File.join(PACKAGE_CONSTRUCTION_DIR, "#{orig_tar_ball_name(config)}.orig.tar.gz")

  # The File task to construct the original source tarball.
  file orig_source_tarball_path => PACKAGE_CONSTRUCTION_DIR do
    system "tar zcf #{orig_source_tarball_path} --directory #{PACKAGE_CONSTRUCTION_DIR} #{source_dir_name(config)}"
  end

  # The path to the debian directory within the extracted source directory
  package_debian_path = File.join(pkg_src_dir, 'debian')

  # Directory task to the package debian path to ensure existence.
  directory package_debian_path

  # The task that actually constructs the debian package
  task package_task_name => orig_source_tarball_path do
    # Build the spanky little thing.
    debuild_flag = ENV['debuild'] || 'true'
    if debuild_flag == 'true'
      system "cd #{pkg_src_dir}; debuild -us -uc"
    else
      puts "Skipping build; debug flag was set"
    end
  end

  # Ensure we have set up the tasks for all the files to be included
  # in the package.
  config[:exes].each do | exe_name |
    exe_path = File.join(pkg_src_dir, exe_name.split('.').first)
    file exe_path => pkg_src_dir do
      cp exe_name, exe_path
    end

    # Add the file path as a dependency of the source tarball
    task orig_source_tarball_path => exe_path
  end

  # Create the task to populate the debian directory
  debian_task = "populate_#{config[:package_name]}_debian_files"
  task debian_task => package_debian_path do
    cp_r "package_source/#{config[:package_name]}/debian", pkg_src_dir
  end

  # Finally add the debian task as a dependency for the package task.
  task package_task_name => debian_task
end

def versioned_package_name(config, version_delim='-')
  "#{config[:package_name]}#{version_delim}#{config[:version]}"
end

def orig_tar_ball_name(config)
  versioned_package_name(config, '_')
end

def source_dir_name(config)
  versioned_package_name(config)
end
