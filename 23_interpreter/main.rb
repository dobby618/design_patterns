# 構文木を作る。
# program request 4 repeat 3 go right go left end right end end

class ParseException < StandardError; end

class Context
  attr_reader :current_token

  def initialize(text)
    @tokens = text.split
    next_token
  end

  def next_token
    @current_token = @tokens.shift
  end

  def skip_token(token)
    if token != current_token
      raise ParseException.new "Warning: #{token} is expected, but #{current_token} is found"
    end
    next_token
  end
end

# <program>           ::= program <command list>
class ProgramNode
  def parse(context)
    context.skip_token('program')
    @command_list_node = CommandListNode.new
    @command_list_node.parse(context)
  end

  def to_s
    "[program #{@command_list_node.to_s}]"
  end
end

# <command list>      ::= <command>* end
class CommandListNode
  def initialize
    @command_nodes = []
  end

  def parse(context)
    while true
      if context.current_token == nil
        raise ParseException.new 'Missing `end`'
      elsif context.current_token == 'end'
        context.skip_token('end')
        break
      else
        command_node = CommandNode.new
        command_node.parse(context)
        @command_nodes << command_node
      end
    end
  end

  def to_s
    @command_nodes.reduce([]) do |result, command_node|
      result << command_node.to_s
    end.join(', ')
  end
end

# <command>           ::= <repeat command> | <primitive command>
class CommandNode
  def parse(context)
    @node = 
      if context.current_token == 'repeat'
        RepeatCommandNode.new
      else
        PrimitiveCommandNode.new
      end

    @node.parse(context)
  end

  def to_s
    @node.to_s
  end
end

# <repeat command>    ::= repeat <number> <command list>
class RepeatCommandNode
  def parse(context)
    context.skip_token('repeat')
    @number = context.current_token
    context.next_token
    @command_list_node = CommandListNode.new
    @command_list_node.parse(context)
  end

  def to_s
    "[repeat #{@number} #{@command_list_node.to_s}]"
  end
end

# <primitive command> ::= go | right | left
class PrimitiveCommandNode
  def parse(context)
    @name = context.current_token
    context.skip_token(@name)
    unless ['go', 'right', 'left'].include?(@name)
      raise ParseException.new "Warning: #{@name} is not expected"
    end
  end

  def to_s
    @name
  end
end

[
  "program end",
  "program go end",
  "program go right go right go right end",
  "program repeat 4 go right end end",
  "program repeat 4 repeat 3 go right go left end right end end",
].each do |text|
  pp text
  node = ProgramNode.new
  node.parse(Context.new(text))
  pp node.to_s  
end

# 解析した構文の使い方が分からない。。
# to_s の部分を何かしらの命令に変えるのかな。
