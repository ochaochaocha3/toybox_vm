require 'toybox_vm/ast/feature'

module ToyboxVm
  module Ast
    class LessThan < Struct.new(:left, :right)
      include Feature::NodeInspection
      include Feature::Noncommutative
      include Feature::ReducibleBinaryOperator

      def precedence
        10
      end

      def to_s
        "#{left} < #{right}"
      end

      def to_s_exp
        "(< #{left.to_s_exp} #{right.to_s_exp})"
      end

      def on_both_are_reduced(*)
        Boolean.new(left.value < right.value)
      end
    end
  end
end
