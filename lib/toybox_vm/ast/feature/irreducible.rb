module ToyboxVm
  module Ast
    module Feature
      # 簡約不可能
      module Irreducible
        def reducible?
          false
        end

        def reduce(roll_results)
          [self, roll_results]
        end
      end
    end
  end
end
