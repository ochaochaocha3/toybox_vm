require 'toybox_vm/ast/feature'

module ToyboxVm
  module Ast
    class Divide < Struct.new(:left, :right)
      include Feature::NodeInspection
      include Feature::LeftAssociativeBinaryOperator
      include Feature::Noncommutative
      include Feature::ReducibleBinaryOperator

      def precedence
        200
      end

      def to_s
        inject_operator('/')
      end

      def to_s_exp
        "(/ #{left.to_s_exp} #{right.to_s_exp})"
      end

      def on_both_are_reduced(roll_results)
        [Number.new(left.value / right.value), roll_results]
      end
    end
  end
end
