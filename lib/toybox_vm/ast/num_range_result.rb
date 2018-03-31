require 'toybox_vm/ast/feature'

module ToyboxVm
  module Ast
    class NumRangeResult < Struct.new(:num_range, :value)
      include Feature::NodeInspection

      def reducible?
        true
      end

      def precedence
        20
      end

      def to_s
        "#{num_range} -> #{value}"
      end

      def to_s_exp
        "(num-range-result #{value} #{num_range.to_s_exp})"
      end

      def reduce(*)
        Number.new(value)
      end
    end
  end
end
