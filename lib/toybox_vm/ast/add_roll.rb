require 'toybox_vm/ast/feature'

require 'toybox_vm/ast/number'
require 'toybox_vm/ast/die_roll_result'
require 'toybox_vm/ast/add_roll_result'

module ToyboxVm
  module Ast
    class AddRoll < Struct.new(:num_of_dice, :max_value)
      include Feature::NodeInspection
      include Feature::Parenthesization
      include Feature::Undetermined

      def reducible?
        true
      end

      def precedence
        1000
      end

      def to_s
        _, num_of_dice_str = parenthesize_by_precedence(num_of_dice)
        _, max_value_str = parenthesize_by_precedence(max_value)

        "#{num_of_dice_str}D#{max_value_str}"
      end

      def to_s_exp
        "(add-roll #{num_of_dice.to_s_exp} #{max_value.to_s_exp})"
      end

      def reduce(roll_results)
        if num_of_dice.reducible?
          reduced_num_of_dice, new_roll_results = num_of_dice.reduce(roll_results)
          [self.class.new(reduced_num_of_dice, max_value), new_roll_results]
        elsif max_value.reducible?
          reduced_max_value, new_roll_results = max_value.reduce(roll_results)
          [self.class.new(num_of_dice, reduced_max_value), new_roll_results]
        else
          on_both_are_reduced(roll_results)
        end
      end

      def on_both_are_reduced(current_roll_results)
        num_of_dice_value = num_of_dice.value

        unless num_of_dice_value > 0
          raise RangeError, "AddRoll: num_of_dice (#{num_of_dice_value}) must be greater than 0"
        end

        max_value_value = max_value.value

        # TODO: テストの場合は外部からふった結果を読み込む必要がある
        roll_results = Array.new(num_of_dice.value) {
          DieRollResult.new(rand(1..max_value_value), max_value_value)
        }

        [AddRollResult.new(self, roll_results), current_roll_results + roll_results]
      end
    end
  end
end
