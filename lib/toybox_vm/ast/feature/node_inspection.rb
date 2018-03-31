module ToyboxVm
  module Ast
    module Feature
      module NodeInspection
        # ノードを分かりやすく表示する
        def inspect
          "<<#{self}>>"
        end
      end
    end
  end
end
