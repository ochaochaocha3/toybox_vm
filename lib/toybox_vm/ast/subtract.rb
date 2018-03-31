require 'toybox_vm/ast/feature'

require 'toybox_vm/ast/number'

module ToyboxVm
  module Ast
    class Subtract < Struct.new(:left, :right)
      include Feature::NodeInspection
      include Feature::LeftAssociativeBinaryOperator
      include Feature::Noncommutative
      include Feature::ReducibleBinaryOperator

      def precedence
        100
      end

      def to_s
        inject_operator('-')
      end

      def to_s_exp
        "(- #{left.to_s_exp} #{right.to_s_exp})"
      end

      def on_both_are_reduced(*)
        Number.new(left.value - right.value)
      end
    end
  end
end
