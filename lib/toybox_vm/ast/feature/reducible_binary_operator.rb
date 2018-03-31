module ToyboxVm
  module Ast
    module Feature
      # 簡約可能な2項演算子
      module ReducibleBinaryOperator
        def reducible?
          true
        end

        def reduce(state)
          if left.reducible?
            reduced_left = left.reduce(state)
            self.class.new(reduced_left, right)
          elsif right.reducible?
            reduced_right = right.reduce(state)
            self.class.new(left, reduced_right)
          else
            on_both_are_reduced(state)
          end
        end

        def on_both_are_reduced(*)
          self
        end

        def determined?
          left.determined? && right.determined?
        end
      end
    end
  end
end
