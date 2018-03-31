module ToyboxVm
  module SyntaxNode
    module LeftAssociative
      module_function
      # 左結合の抽象構文木への変換
      def to_ast(first, rest)
        rest.elements.reduce(first.to_ast) { |ast, element|
          element.operator.ast_class.new(ast, element.operand.to_ast)
        }
      end
    end
  end
end
