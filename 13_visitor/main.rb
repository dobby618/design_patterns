
class Entry
  class FileTreatmentException < StandardError; end

  def add(entry)
    raise FileTreatmentException
  end

  def to_string
    "#{name}（#{size}）"
  end
end


class FileEntry < Entry
  attr_reader :name, :size

  def initialize(name, size)
    @name = name
    @size = size
  end

  def accept(visitor)
    visitor.visit(self)
  end
end

class DirectoryEntry < Entry
  attr_reader :name, :entries

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

  def accept(visitor)
    visitor.visit(self)
  end

  # Array#eachからRubyのブロックを理解する
  # https://qiita.com/bisque33/items/4e09257945b883628703
  def each(&block) # TODO each の委譲できるようにする。
    @entries.each(&block)
  end
end

# 全ての家に順次、家→部屋全部尋ねる、次の家→部屋全部尋ねる、みたいなイメージ
class ListVisitor
  def initialize
    @current_directory = ''
  end

  def visit(entry) # 単数か複数がくる可能性があって、名前が難しい…＞＜
    if entry.is_a?(FileEntry)
      pp "#{@current_directory}/#{entry.to_string}"
    elsif entry.is_a?(DirectoryEntry)
      pp "#{@current_directory}/#{entry.to_string}"
      save_directory = @current_directory

      # pp "#{entry.name} の entry.each 前"
      # pp "#{entry.entries}"
      @current_directory = "#{@current_directory}/#{entry.name}"
      entry.each do |e|
        # pp "#{entry.name} の entry.each 中"
        # pp "#{e.name}"
        e.accept(self)
      end

      @current_directory = save_directory # １つ上の階層に戻す（尋ねる・1個深く潜る前の階層に戻る）
    else
      raise '想定外の型！'
    end
  end
end

# main
begin
  p "Making root entries"
  rootdir = DirectoryEntry.new("root")
  bindir = DirectoryEntry.new("bin")
  usrdir = DirectoryEntry.new("usr")
  rootdir.add(bindir)
  rootdir.add(usrdir)
  bindir.add(FileEntry.new("vi", 100000))
  bindir.add(FileEntry.new("latex", 200000))
  rootdir.accept(ListVisitor.new)

  p "Making user entries"
  yuki = DirectoryEntry.new("yuki")
  hanako = DirectoryEntry.new("hanako")
  tomura = DirectoryEntry.new("tomura")
  usrdir.add(yuki)
  usrdir.add(hanako)
  usrdir.add(tomura)
  yuki.add(FileEntry.new("dirary.html", 100))
  yuki.add(FileEntry.new("Composite.java", 200))
  hanako.add(FileEntry.new("memo.txt", 300))
  tomura.add(FileEntry.new("game.doc", 400))
  tomura.add(FileEntry.new("junk.mail", 500))

  rootdir.accept(ListVisitor.new)

rescue Entry::FileTreatmentException
  p "追加できません！"
end
