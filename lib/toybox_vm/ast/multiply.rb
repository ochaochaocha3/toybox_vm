require 'toybox_vm/ast/feature'

module ToyboxVm
  module Ast
    class Multiply < Struct.new(:left, :right)
      include Feature::NodeInspection
      include Feature::LeftAssociativeBinaryOperator
      include Feature::Commutative
      include Feature::ReducibleBinaryOperator

      def precedence
        200
      end

      def to_s
        inject_operator('*')
      end

      def to_s_exp
        "(* #{left.to_s_exp} #{right.to_s_exp})"
      end

      def on_both_are_reduced(*)
        Number.new(left.value * right.value)
      end
    end
  end
end
