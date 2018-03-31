module ToyboxVm
  module Ast
    module Feature
      # 左結合の2項演算子
      module LeftAssociativeBinaryOperator
        include Parenthesization

        private

        # 演算子を間に入れる
        # @return [String]
        def inject_operator(operator, inject_spaces = true)
          is_left_parenthesized, left_str = parenthesize_by_precedence(left)
          is_right_parenthesized, right_str_1 = parenthesize_by_precedence(right)
          right_str =
            if right.precedence == self.precedence && right.kind_of?(Noncommutative)
              "(#{right_str_1})"
            else
              right_str_1
            end

          [left_str, operator, right_str].join(inject_spaces ? ' ' : '')
        end
      end
    end
  end
end
