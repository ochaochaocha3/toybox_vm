require 'test_helper'

module ToyboxVm
  class DiceRollLangParserTest < Test::Unit::TestCase
    setup do
      @parser = ToyboxVm::DiceRollLangParser.new
    end

    test '1+2' do
      ast = @parser.ast('1+2')
      assert_equal('(+ 1 2)', ast.to_s_exp)
    end

    test '1+2*3' do
      ast = @parser.ast('1+2*3')
      assert_equal('(+ 1 (* 2 3))', ast.to_s_exp)
    end

    test '(1+2)*3' do
      ast = @parser.ast('(1+2)*3')
      assert_equal('(* (+ 1 2) 3)', ast.to_s_exp)
    end

    test '1+-' do
      ast = @parser.ast('1+-')
      assert_nil(ast)
    end

    test '2d6' do
      ast_downcase = @parser.ast('2d6')
      assert_equal('(add-roll 2 6)', ast_downcase.to_s_exp)

      ast_upcase = @parser.ast('2D6')
      assert_equal('(add-roll 2 6)', ast_upcase.to_s_exp)
    end

    test '(1+2)d6' do
      ast = @parser.ast('(1+2)d6')
      assert_equal('(add-roll (+ 1 2) 6)', ast.to_s_exp)
    end
  end
end
