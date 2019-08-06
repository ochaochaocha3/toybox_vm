require 'test_helper'

require 'ast'
require 'toybox_vm/parser/arithmetic_parser'

module ToyboxVm
  module Parser
    ArithmeticParserTestData = Struct.new(:input, :error, :expected_sexp)

    class ParserTest < Test::Unit::TestCase
      class << self
        include AST::Sexp

        def parser_test_data(input, error, expected_sexp)
          data(input.inspect,
               ArithmeticParserTestData.new(input, error, expected_sexp))
        end
      end

      # 整数
      parser_test_data('1', false, s(:integer, 1))
      parser_test_data('42', false, s(:integer, 42))

      # 単項演算子
      parser_test_data(
        '-1', false,
        s(:unary_minus,
          s(:integer, 1))
      )
      parser_test_data('+1', false, s(:integer, 1))

      test '構文解析器が正しい抽象構文木を返す' do |data|
        parser = ArithmeticParser.new(data.input)

        if data.error
          assert_raise(Racc::Error) do
            parser.parse
          end
        else
          ast = parser.parse
          assert_equal(data.expected_sexp, ast)
        end
      end
    end
  end
end
