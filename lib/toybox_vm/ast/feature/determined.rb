module ToyboxVm
  module Ast
    module Feature
      # 常に決定済み
      module Determined
        def determined?
          true
        end

        def determine
          self
        end
      end

      # 常に未決定
      module Undetermined
        def determined?
          false
        end

        def determine
          raise NotImplementedError
        end
      end
    end
  end
end
