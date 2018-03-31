require 'toybox_vm/ast/feature'

require 'toybox_vm/ast/number'

module ToyboxVm
  module Ast
    class AddRollResult < Struct.new(:add_roll, :roll_results)
      include Feature::NodeInspection
      include Feature::Determined

      # 出目の合計
      # @return [Integer]
      attr_reader :value

      def initialize(*)
        super

        @value = roll_results.map(&:value).sum
      end

      def reducible?
        true
      end

      def precedence
        20
      end

      def to_s
        roll_results_str = roll_results.map(&:value).join(', ')
        "#{add_roll} -> #{value}[#{roll_results_str}]"
      end

      def to_s_exp
        "(add-roll-result #{value} #{add_roll.to_s_exp})"
      end

      def reduce(*)
        Number.new(value)
      end
    end
  end
end
