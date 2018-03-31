module ToyboxVm
  module Ast
    module Feature
      # 可換な2項演算子
      module Commutative
        def commutative?
          true
        end
      end

      # 非可換な2項演算子
      module Noncommutative
        def commutative?
          false
        end
      end
    end
  end
end
