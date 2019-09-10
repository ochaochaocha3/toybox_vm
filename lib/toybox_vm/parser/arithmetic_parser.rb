# frozen_string_literal: true

require 'parslet'

module ToyboxVm
  module Parser
    class ArithmeticParser < Parslet::Parser
      root(:additive)

      rule(:additive) {
        multitive.as(:first) >>
        (match['-+'].as(:op) >> multitive.as(:operand)).repeat.as(:rest)
      }

      rule(:multitive) {
        primary.as(:first) >>
        (match['*/'].as(:op) >> primary.as(:operand)).repeat.as(:rest)
      }

      rule(:primary) { unary_plus | unary_minus | integer }
      rule(:unary_plus) { str('+') >> primary }
      rule(:unary_minus) { str('-').as(:op) >> primary.as(:right) }
      rule(:integer) { match('[0-9]').repeat(1).as(:integer) }
    end
  end
end
