require 'rake/clean'
HOME = ENV["HOME"]
CURRENT = Dir.pwd
includes = []
excludes = []

if FileTest.exist?(".exclude.dotfiles")
  File.open(".exclude.dotfiles") do |io|
    io.each do |line|
      line.chomp!
      next if line == ""
      excludes.push(line)
    end
  end
end

if FileTest.exist?(".include.dotfiles")
  File.open(".include.dotfiles") do |io|
    io.each do |line|
      line.chomp!
      next if line == ""
      includes.push(line)
    end
  end
end

Dir.chdir HOME
if includes.length > 0
  dotfiles = FileList[*includes]
else
  dotfiles = FileList[".*"]
end
dotfiles.exclude(/\.$/,
                 /history$/,
                 ".ssh",
                 ".DS_Store",
                 ".Trash")
dotfiles.exclude(*excludes)

dotfiles.each do |file|
  dotfiles.include(FileList[File.join(file,"**","*")])
end

Dir.chdir CURRENT
copyfiles = FileList[".*"]
copyfiles.exclude(/\.$/,".git",".exclude.dotfiles",".include.dotfiles")
CLEAN.include(copyfiles)

task :will_import do |t|
  dotfiles.each{|file_name|
    puts file_name
  }
end

task :import => dotfiles

rule(/^\./ => [
                 proc{|file_name| File.join(HOME,file_name)}
                ]) do |t|
  dest = File.join(CURRENT,t.name)
  if File.ftype(t.source) == "directory"
    mkdir_p dest, {:verbose => true, :noop => true}
  else
    install t.source, dest, {:verbose => true, :noop => true}
  end
end

task :delete_original => copyfiles do |t|
  copyfiles.each{|file|
    if FileTest.exist?(File.join(HOME,file))
      rm_r File.join(HOME,file), {:force => true, :verbose => true}
    end
  }
end

task :symlink => copyfiles do |t|
  copyfiles.each{|file|
    if split_all(file).length == 1
      symlink File.join(CURRENT,file), File.join(HOME,file), {:verbose => true}
    end
  }
end

task :force_symlink => [:delete_original, :symlink]

task :export => copyfiles do |t|
  copyfiles.each{|file|
    if split_all(file).length == 1
      cp_r File.join(CURRENT,file), File.join(HOME,file), {:verbose => true}
    end
  }
end

task :force_export => [:delete_original, :export]

