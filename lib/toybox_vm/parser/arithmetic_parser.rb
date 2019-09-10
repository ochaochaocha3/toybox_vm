require 'parslet'

module ToyboxVm
  module Parser
    class ArithmeticParser < Parslet::Parser
      root(:primary)

      rule(:primary) { unary_plus | unary_minus | integer }
      rule(:unary_plus) { str('+') >> primary }
      rule(:unary_minus) { str('-').as(:op) >> primary.as(:right) }
      rule(:integer) { match('[0-9]').repeat(1).as(:integer) }
    end
  end
end
