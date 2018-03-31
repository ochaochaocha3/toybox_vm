require 'test_helper'

module ToyboxVm
  module Ast
    class AddRollTest < Test::Unit::TestCase
      def self.ast_2d6
        AddRoll.new(Number.new(2), Number.new(6))
      end

      def self.ast_add
        AddRoll.new(
          Add.new(Number.new(1), Number.new(2)),
          Number.new(6)
        )
      end

      data(
        '2d6' => ['2D6', ast_2d6],
        '(1+2)d6' => ['(1 + 2)D6', ast_add]
      )

      test 'to_s' do |(expected, ast)|
        assert_equal(expected, ast.to_s)
      end

      data(
        '2d6' => ['(add-roll 2 6)', ast_2d6],
        '(1+2)d6' => ['(add-roll (+ 1 2) 6)', ast_add]
      )

      test 'to_s_exp' do |(expected, ast)|
        assert_equal(expected, ast.to_s_exp)
      end

      data(
        '2d6' => ast_2d6,
        '(1+2)d6' => ast_add
      )

      test 'reducible' do |ast|
        assert { ast.reducible? }
      end
    end
  end
end
