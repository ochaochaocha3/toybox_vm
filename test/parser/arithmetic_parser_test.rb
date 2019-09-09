require 'test_helper'

require 'ast'
require 'toybox_vm/parser/arithmetic_parser'
require 'toybox_vm/transform/arithmetic_transform'

module ToyboxVm
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

=begin
    # 単項演算子
    parser_test_data(
      '-1', false,
      s(:unary_minus,
        s(:integer, 1))
    )
    parser_test_data('+1', false, s(:integer, 1))

    # 算術演算子
    parser_test_data(
      '1+2', false,
      s(:add,
        s(:integer, 1),
        s(:integer, 2))
    )
    parser_test_data(
      '1-2', false,
      s(:subtract,
        s(:integer, 1),
        s(:integer, 2))
    )
    parser_test_data(
      '1*2', false,
      s(:multiply,
        s(:integer, 1),
        s(:integer, 2))
    )
    parser_test_data(
      '1/2', false,
      s(:divide,
        s(:integer, 1),
        s(:integer, 2))
    )
=end

    test '構文解析器が正しい抽象構文木を返す' do |data|
      parser = Parser::ArithmeticParser.new

      if data.error
        assert_raise(Parslet::ParseFailed) do
          parser.parse(data.input)
        end
      else
        tree = parser.parse(data.input)
        ast = Transform::ArithmeticTransform.new.apply(tree)
        assert_equal(data.expected_sexp, ast)
      end
    end
  end
end
