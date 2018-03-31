require 'toybox_vm/machine_state'

module ToyboxVm
  class Machine
    attr_reader :state

    def initialize(ast, roll_queue = nil, num_range_queue = nil, random = Random::DEFAULT)
      @roll_results = []
      @ast = ast

      @state = MachineState.new(roll_queue, num_range_queue, random)
    end

    def roll_results
      @roll_results.dup
    end

    def run(trace = false)
      target = @ast
      puts("Initial:\n  #{target.to_s}") if trace
      while target.reducible?
        target, @roll_results = target.reduce(@state)

        if trace
          puts("Reduced:")
          puts("  #{target.to_s}")
          puts("  Roll results: #{@state.roll_results}")
          puts("  Num range results: #{@state.num_range_results}")
        end
      end

      target
    end
  end
end
