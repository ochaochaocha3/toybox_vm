require 'test_helper'

module ToyboxVm
  module Ast
    class NumberTest < Test::Unit::TestCase
      data(
        0 => [0, Number.new(0)],
        1 => [1, Number.new(1)]
      )

      test 'value' do |(expected, ast)|
        assert_equal(expected, ast.value)
      end

      data(
        0 => Number.new(0),
        1 => Number.new(1)
      )

      test 'irreducible' do |ast|
        refute(ast.reducible?)
      end

      data(
        0 => Number.new(0),
        1 => Number.new(1)
      )

      test 'determined' do |ast|
        assert(ast.determined?)
      end
    end
  end
end
