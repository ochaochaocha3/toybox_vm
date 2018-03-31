require 'toybox_vm/ast/die_roll_result'
require 'toybox_vm/ast/num_range_result'

module ToyboxVm
  class MachineState
    class EmptyRollQueueError < StandardError; end
    class EmptyNumRangeQueueError < StandardError; end

    attr_reader :roll_queue
    attr_reader :num_range_queue
    attr_reader :roll_results
    attr_reader :num_range_results

    def initialize(roll_queue = nil, num_range_queue = nil, random = Random::DEFAULT)
      @roll_queue = roll_queue.dup
      @num_range_queue = num_range_queue.dup

      @random = random

      @roll_results = []
      @num_range_results = []
    end

    def roll_die!(max_value)
      result =
        if @roll_queue
          if @roll_queue.empty?
            raise EmptyRollQueueError, 'Roll queue is empty. Please provide enough results.'
          end

          @roll_queue.shift
        else
          value = @random.rand(1..max_value)
          Ast::DieRollResult.new(value, max_value)
        end

      unless result.max_value == max_value
        raise ArgumentError, "result's max value (#{result.max_value}) is not equal to the specified (#{max_value})"
      end

      @roll_results << result

      result
    end

    def get_value_in_num_range!(num_range)
      result =
        if @num_range_queue
          if @num_range_queue.empty?
            raise EmptyNumRangeQueueError, 'Num range queue is empty. Please provide enough results.'
          end

          @num_range_queue.shift
        else
          min_value = num_range.min.value
          max_value = num_range.max.value

          if min_value > max_value
            raise RangeError, "NumRange: min must be equal or less than max (min = #{min}, max = #{max})"
          end

          value = @random.rand(min_value..max_value)
          Ast::NumRangeResult.new(num_range, value)
        end

      unless result.num_range == num_range
        raise ArgumentError, "result's num range (#{result.num_range}) is not equal to the specified (#{num_range})"
      end

      @num_range_results << result

      result
    end
  end
end
