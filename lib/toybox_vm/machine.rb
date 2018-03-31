module ToyboxVm
  class Machine
    def initialize(ast)
      @roll_results = []
      @ast = ast
    end

    def roll_results
      @roll_results.dup
    end

    def run
      target = @ast
      puts("Initial:\n  #{target.to_s}")
      while target.reducible?
        target, @roll_results = target.reduce(@roll_results)
        puts("Reduced:")
        puts("  #{target.to_s}")
        puts("  Roll results: #{@roll_results}")
      end

      target
    end
  end
end
