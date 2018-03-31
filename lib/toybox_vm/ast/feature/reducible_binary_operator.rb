module ToyboxVm
  module Ast
    module Feature
      # 簡約可能な2項演算子
      module ReducibleBinaryOperator
        def reducible?
          true
        end

        def reduce(roll_results)
          if left.reducible?
            reduced_left, new_roll_results = left.reduce(roll_results)
            [self.class.new(reduced_left, right), new_roll_results]
          elsif right.reducible?
            reduced_right, new_roll_results = right.reduce(roll_results)
            [self.class.new(left, reduced_right), new_roll_results]
          else
            on_both_are_reduced(roll_results)
          end
        end

        def on_both_are_reduced(roll_results)
          [self, roll_results]
        end

        def determined?
          left.determined? && right.determined?
        end
      end
    end
  end
end
