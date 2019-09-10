# frozen_string_literal: true

require 'parslet'
require 'ast'

module ToyboxVm
  module Transform
    class ArithmeticTransform < Parslet::Transform
      rule(first: simple(:first), rest: subtree(:rest)) {
        rest.reduce(first) { |acc, e|
          op = e[:op]
          operand = e[:operand]

          node_type =
            case op
            when '+'
              :add
            when '-'
              :subtract
            when '*'
              :multiply
            when '/'
              :divide
            else
              raise NotImplementedError, "unknown operator: #{op}"
            end
          AST::Node.new(node_type, [acc, operand])
        }
      }

      rule(op: '-', right: simple(:right)) {
        AST::Node.new(:unary_minus, [right])
      }

      rule(integer: simple(:x)) { AST::Node.new(:integer, [x.to_i]) }
    end
  end
end
