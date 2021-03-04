require 'tk'

class MacroCommand
  def initialize
    @commands = []
  end

  def execute
    @commands.each(&:pack) # pack: ウインドウに要素を載せる
    Tk.mainloop
  end

  def append(command)
    @commands << command if command != self
  end

  def undo(command)
    @commands.pop if !@commands.empty?
  end

  def clear
    @commands.clear
  end
end


macro_command = MacroCommand.new
macro_command.append(TkButton.new(text: 'Greet', command: proc { print "Hi!!\n" }))
macro_command.append(TkButton.new(text: 'Exit', command: proc { exit }))

macro_command.execute
