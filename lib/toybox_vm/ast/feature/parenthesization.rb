module ToyboxVm
  module Ast
    module Feature
      module Parenthesization
        # 優先度を利用して括弧で囲む
        # @param [Object] element 対象要素
        # @return [Array] 括弧で囲んだかと変換後の結果
        def parenthesize_by_precedence(element)
          if element.precedence < self.precedence
            [true, "(#{element})"]
          else
            [false, element.to_s]
          end
        end
      end
    end
  end
end
