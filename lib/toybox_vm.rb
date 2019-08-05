module ToyboxVm
  class Error < StandardError; end
  # Your code goes here...
end

require 'toybox_vm/version'

require 'toybox_vm/ast'
require 'toybox_vm/machine_state'
require 'toybox_vm/machine'

require 'treetop'
Treetop.load(
  File.expand_path('toybox_vm/dice_roll_lang', File.dirname(__FILE__))
)
