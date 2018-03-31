module ToyboxVm
  module Ast
    module Feature
    end
  end
end

require 'toybox_vm/ast/feature/node_inspection'
require 'toybox_vm/ast/feature/parenthesization'
require 'toybox_vm/ast/feature/irreducible'
require 'toybox_vm/ast/feature/determined'
require 'toybox_vm/ast/feature/commutativity'
require 'toybox_vm/ast/feature/left_associative_binary_operator'
require 'toybox_vm/ast/feature/reducible_binary_operator'
