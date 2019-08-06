class ToyboxVm::Parser::ArithmeticParser

prechigh
  nonassoc UNARY_MINUS UNARY_PLUS
preclow

rule
  expr
    : integer
    | MINUS expr =UNARY_MINUS {
      result = s(:unary_minus, val[1])
    }
    | PLUS expr =UNARY_PLUS {
      result = val[1]
    }

  integer
    : INTEGER {
      value = val[0].literal.to_i
      result = s(:integer, value)
    }
end

---- header

require 'ast'
require 'toybox_vm/lexer'

---- inner

include AST::Sexp

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
