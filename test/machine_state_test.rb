require 'test_helper'

module ToyboxVm
  class MachineStateTest < Test::Unit::TestCase
    def new_roll_queue
      [
        Ast::DieRollResult.new(1, 6),
        Ast::DieRollResult.new(2, 6),
        Ast::DieRollResult.new(4, 6),
        Ast::DieRollResult.new(6, 6)
      ]
    end

    def new_num_range_queue
      [
        Ast::NumRangeResult.new(
          Ast::NumRange.new(Ast::Number.new(1), Ast::Number.new(3)),
          1
        ),
        Ast::NumRangeResult.new(
          Ast::NumRange.new(Ast::Number.new(1), Ast::Number.new(3)),
          3
        ),
        Ast::NumRangeResult.new(
          Ast::NumRange.new(Ast::Number.new(1), Ast::Number.new(3)),
          2
        )
      ]
    end

    test 'roll_queue' do
      state = MachineState.new(new_roll_queue)

      assert_equal(Ast::DieRollResult.new(1, 6), state.roll_die!(6))
      assert_equal(Ast::DieRollResult.new(2, 6), state.roll_die!(6))
      assert_equal(Ast::DieRollResult.new(4, 6), state.roll_die!(6))
      assert_equal(Ast::DieRollResult.new(6, 6), state.roll_die!(6))

      assert_equal(4, state.roll_results.length)

      assert { state.roll_queue.empty? }
      assert_raise(MachineState::EmptyRollQueueError) do
        state.roll_die!(6)
      end
    end

    test 'roll_queue: different max value' do
      state = MachineState.new(new_roll_queue)

      assert_raise(ArgumentError) do
        state.roll_die!(5)
      end
    end

    test 'num_range_queue' do
      state = MachineState.new(nil, new_num_range_queue)

      num_range = Ast::NumRange.new(Ast::Number.new(1), Ast::Number.new(3))
      assert_equal(
        Ast::NumRangeResult.new(num_range, 1),
        state.get_value_in_num_range!(num_range)
      )
      assert_equal(
        Ast::NumRangeResult.new(num_range, 3),
        state.get_value_in_num_range!(num_range)
      )
      assert_equal(
        Ast::NumRangeResult.new(num_range, 2),
        state.get_value_in_num_range!(num_range)
      )

      assert_equal(3, state.num_range_results.length)

      assert { state.num_range_queue.empty? }
      assert_raise(MachineState::EmptyNumRangeQueueError) do
        state.get_value_in_num_range!(num_range)
      end
    end

    test 'num_range_queue: different num range' do
      state = MachineState.new(nil, new_num_range_queue)

      assert_raise(ArgumentError) do
        state.get_value_in_num_range!(Ast::NumRange.new(Ast::Number.new(0), Ast::Number.new(5)))
      end
    end
  end
end
