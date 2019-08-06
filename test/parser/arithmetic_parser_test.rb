require 'test_helper'

require 'ast'
require 'toybox_vm/parser/arithmetic_parser'

module ToyboxVm
  module Parser
    ArithmeticParserTestData = Struct.new(:input, :error, :expected_sexp)

    class ParserTest < Test::Unit::TestCase
      class << self
        include AST::Sexp
      end

      data(
        '1'.inspect,
        ArithmeticParserTestData.new(
          '1',
          false,
          s(:integer, 1)
        )
      )
      data(
        '42'.inspect,
        ArithmeticParserTestData.new(
          '42',
          false,
          s(:integer, 42)
        )
      )

      test '構文解析器が正しい抽象構文木を返す' do |data|
        parser = ArithmeticParser.new(data.input)

        if data.error
          assert_raise(RuntimeError) do
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
