require 'parslet'

module ToyboxVm
  module Parser
    class ArithmeticParser < Parslet::Parser
      rule(:integer) { match('[0-9]').repeat(1).as(:integer) }
      root(:integer)
    end
  end
end
