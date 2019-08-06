class ToyboxVm::Parser::ArithmeticParser

prechigh
  nonassoc UNARY_MINUS UNARY_PLUS
  ASTERISK SLASH
  PLUS MINUS
preclow

rule
  expr
    : integer
    | MINUS expr =UNARY_MINUS {
      result = AST::Node.new(:unary_minus, [val[1]], token: val[0])
    }
    | PLUS expr =UNARY_PLUS {
      result = val[1]
    }
    | expr PLUS expr {
      result = AST::Node.new(:add, [val[0], val[2]], token: val[1])
    }
    | expr MINUS expr {
      result = AST::Node.new(:subtract, [val[0], val[2]], token: val[1])
    }
    | expr ASTERISK expr {
      result = AST::Node.new(:multiply, [val[0], val[2]], token: val[1])
    }
    | expr SLASH expr {
      result = AST::Node.new(:divide, [val[0], val[2]], token: val[1])
    }

  integer
    : INTEGER {
      value = val[0].literal.to_i
      result = AST::Node.new(:integer, [value], token: val[0])
    }
end

---- header

require 'ast'
require 'toybox_vm/lexer'

---- inner

attr_reader :input

def initialize(input)
  @input = input
  @lexer = Lexer.new(input)
end

def parse
  do_parse
end

def next_token
  tok = @lexer.next_token

  if tok.type == :EOS
    [false, tok]
  else
    [tok.type, tok]
  end
end

---- footer
