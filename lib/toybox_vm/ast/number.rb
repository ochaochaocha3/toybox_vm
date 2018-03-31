require 'toybox_vm/ast/feature'

module ToyboxVm
  module Ast
    class Number < Struct.new(:value)
      include Feature::NodeInspection
      include Feature::Irreducible
      include Feature::Determined

      def precedence
        20000
      end

      def to_s
        value.to_s
      end

      def to_s_exp
        self.to_s
      end
    end
  end
end
