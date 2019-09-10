require 'parslet'
require 'ast'

module ToyboxVm
  module Transform
    class ArithmeticTransform < Parslet::Transform
      rule(op: '-', right: simple(:right)) {
        AST::Node.new(:unary_minus, [right])
      }

      rule(integer: simple(:x)) { AST::Node.new(:integer, [x.to_i]) }
    end
  end
end
