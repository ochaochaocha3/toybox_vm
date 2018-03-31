require 'test_helper'

module ToyboxVm
  class MachineTest < Test::Unit::TestCase
    setup do
      @parser = DiceRollLangParser.new
    end

    test '1+2' do
      ast = @parser.ast('1+2')
      refute_nil(ast)

      machine = Machine.new(ast)
      result = machine.run

      assert_equal(Ast::Number.new(3), result)
    end

    test '2d6' do
      ast = @parser.ast('2d6')
      refute_nil(ast)

      roll_queue = [
        Ast::DieRollResult.new(3, 6),
        Ast::DieRollResult.new(5, 6)
      ]

      machine = Machine.new(ast, roll_queue)
      result = machine.run

      assert_equal(Ast::Number.new(8), result)
      assert_equal(2, machine.state.roll_results.length)
    end

    test '[1...3]' do
      ast = @parser.ast('[1...3]')
      refute_nil(ast)

      num_range = Ast::NumRange.new(Ast::Number.new(1), Ast::Number.new(3))
      num_range_queue = [
        Ast::NumRangeResult.new(num_range, 3)
      ]

      machine = Machine.new(ast, nil, num_range_queue)
      result = machine.run

      assert_equal(Ast::Number.new(3), result)
      assert_equal(1, machine.state.num_range_results.length)
    end

    test '[2...4]d10' do
      p ast = @parser.ast('[2...4]d10')
      refute_nil(ast)

      roll_queue = [
        Ast::DieRollResult.new(5, 10),
        Ast::DieRollResult.new(3, 10),
        Ast::DieRollResult.new(9, 10)
      ]

      num_range = Ast::NumRange.new(Ast::Number.new(2), Ast::Number.new(4))
      num_range_queue = [
        Ast::NumRangeResult.new(num_range, 3)
      ]

      machine = Machine.new(ast, roll_queue, num_range_queue)
      result = machine.run(true)

      assert_equal(Ast::Number.new(17), result)
      assert_equal(3, machine.state.roll_results.length)
      assert_equal(1, machine.state.num_range_results.length)
    end
  end
end
