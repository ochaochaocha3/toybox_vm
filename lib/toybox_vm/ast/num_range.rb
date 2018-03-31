require 'toybox_vm/ast/feature'

require 'toybox_vm/ast/number'

module ToyboxVm
  module Ast
    class NumRange < Struct.new(:min, :max)
      include Feature::NodeInspection
      include Feature::Parenthesization
      include Feature::Undetermined

      def reducible?
        true
      end

      def precedence
        2000
      end

      def to_s
        _, min_str = parenthesize_by_precedence(min)
        _, max_str = parenthesize_by_precedence(max)

        "[#{min_str}...#{max_str}]"
      end

      def to_s_exp
        "(num-range #{min.to_s_exp} #{max.to_s_exp})"
      end

      def reduce(roll_results)
        if min.reducible?
          reduced_min, new_roll_results = min.reduce(roll_results)
          [self.class.new(reduced_min, max), new_roll_results]
        elsif max.reducible?
          reduced_max, new_roll_results = max.reduce(roll_results)
          [self.class.new(min, reduced_max), new_roll_results]
        else
          on_both_are_reduced(roll_results)
        end
      end

      def on_both_are_reduced(roll_results)
        min_value = min.value
        max_value = max.value

        if min_value > max_value
          raise RangeError, "NumRange: min must be equal or less than max (min = #{min}, max = #{max})"
        end

        value = rand(min_value..max_value)
        [Number.new(value), roll_results]
      end
    end
  end
end
