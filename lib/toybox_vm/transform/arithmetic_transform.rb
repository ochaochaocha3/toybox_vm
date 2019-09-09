require 'parslet'
require 'ast'

module ToyboxVm
  module Transform
    class ArithmeticTransform < Parslet::Transform
      rule(integer: simple(:x)) { AST::Node.new(:integer, [x.to_i]) }
    end
  end
end
