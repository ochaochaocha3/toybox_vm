module ToyboxVm
  module ParserMethods
    def ast(str)
      parse_tree = parse(str)
      return nil unless parse_tree

      parse_tree.to_ast
    end
  end
end
