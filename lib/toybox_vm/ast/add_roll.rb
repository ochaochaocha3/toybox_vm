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

      def reduce(state)
        if num_of_dice.reducible?
          reduced_num_of_dice = num_of_dice.reduce(state)
          self.class.new(reduced_num_of_dice, max_value)
        elsif max_value.reducible?
          reduced_max_value, new_roll_results = max_value.reduce(state)
          self.class.new(num_of_dice, reduced_max_value)
        else
          on_both_are_reduced(state)
        end
      end

      def on_both_are_reduced(state)
        num_of_dice_value = num_of_dice.value

        unless num_of_dice_value > 0
          raise RangeError, "AddRoll: num_of_dice (#{num_of_dice_value}) must be greater than 0"
        end

        max_value_value = max_value.value

        roll_results = Array.new(num_of_dice.value) {
          state.roll_die!(max_value_value)
        }

        AddRollResult.new(self, roll_results)
      end
    end
  end
end
