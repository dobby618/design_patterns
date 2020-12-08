
class Entry
  class FileTreatmentException < StandardError; end

  def add(entry)
    raise FileTreatmentException
  end

  def to_string
    "#{name}（#{size}）"
  end

  def search_result(keyword)
    seach(keyword)
  end
end


class FileEntry < Entry
  attr_reader :name, :size

  def initialize(name, size)
    @name = name
    @size = size
  end

  def print_list(prefix)
    pp prefix + '/' + to_string
  end

  def search(keyword, prefix)
    pp prefix + '/' + name if name == keyword
  end
end

class Directory < Entry
  attr_reader :name

  def initialize(name)
    @name = name
    @entries = []
  end

  def size
    size = 0
    @entries.sum(&:size)
  end

  def add(entry)
    @entries << entry
  end

  def print_list(prefix = "")
    pp prefix + '/' + to_string

    @entries.each do |entry|
      entry.print_list(prefix + '/' + name)
    end
  end

  def search(keyword, prefix = "")
    @entries.each do |entry|
      entry.search(keyword, prefix + '/' + name)
    end
  end
end

# main
begin
  p "Making root entries"
  rootdir = Directory.new("root")
  bindir = Directory.new("bin")
  usrdir = Directory.new("usr")
  rootdir.add(bindir)
  rootdir.add(usrdir)
  bindir.add(FileEntry.new("vi", 100000))
  bindir.add(FileEntry.new("latex", 200000))
  rootdir.print_list

  p "Making user entries"
  yuki = Directory.new("yuki")
  hanako = Directory.new("hanako")
  tomura = Directory.new("tomura")
  usrdir.add(yuki)
  usrdir.add(hanako)
  usrdir.add(tomura)
  yuki.add(FileEntry.new("dirary.html", 100))
  yuki.add(FileEntry.new("Composite.java", 200))
  hanako.add(FileEntry.new("memo.txt", 300))
  tomura.add(FileEntry.new("game.doc", 400))
  tomura.add(FileEntry.new("junk.mail", 500))

  rootdir.print_list
  
  p "Search memo.txt for rootdir"
  rootdir.search("memo.txt") # => /root/usr/hanako/memo.txt

rescue Entry::FileTreatmentException
  p "追加できません！"
end
