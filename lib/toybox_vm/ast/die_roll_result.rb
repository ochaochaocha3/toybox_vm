require 'toybox_vm/ast/feature'

module ToyboxVm
  module Ast
    class DieRollResult < Struct.new(:value, :max_value)
      include Feature::NodeInspection

      def to_s
        "D#{max_value} -> #{value}"
      end
    end
  end
end
