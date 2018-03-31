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

      def reduce(state)
        if min.reducible?
          reduced_min, new_roll_results = min.reduce(state)
          self.class.new(reduced_min, max)
        elsif max.reducible?
          reduced_max, new_roll_results = max.reduce(state)
          self.class.new(min, reduced_max)
        else
          state.get_value_in_num_range!(self)
        end
      end
    end
  end
end
