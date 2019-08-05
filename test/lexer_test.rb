require 'test_helper'

require 'toybox_vm/token'
require 'toybox_vm/lexer'

module ToyboxVm
  LexerTestData = Struct.new(:input, :expected)

  class LexerTest < Test::Unit::TestCase
    data(
      ''.inspect,
      LexerTestData.new('', [Token.new(:EOS, '', 1)])
    )
    data(
      '42'.inspect,
      LexerTestData.new('42', [
        Token.new(:INTEGER, '42', 1),
        Token.new(:EOS, '', 3)
      ])
    )
    data(
      '3d10/4+2*1D6-5'.inspect,
      LexerTestData.new('3d10/4+2*1D6-5', [
        Token.new(:INTEGER, '3', 1),
        Token.new(:D, 'd', 2),
        Token.new(:INTEGER, '10', 3),
        Token.new(:SLASH, '/', 5),
        Token.new(:INTEGER, '4', 6),
        Token.new(:PLUS, '+', 7),
        Token.new(:INTEGER, '2', 8),
        Token.new(:ASTERISK, '*', 9),
        Token.new(:INTEGER, '1', 10),
        Token.new(:D, 'D', 11),
        Token.new(:INTEGER, '6', 12),
        Token.new(:MINUS, '-', 13),
        Token.new(:INTEGER, '5', 14),
        Token.new(:EOS, '', 15)
      ])
    )
    data(
      '((2+3)*4/3)d6*2+5'.inspect,
      LexerTestData.new('((2+3)*4/3)d6*2+5', [
        Token.new(:L_PAREN, '(', 1),
        Token.new(:L_PAREN, '(', 2),
        Token.new(:INTEGER, '2', 3),
        Token.new(:PLUS, '+', 4),
        Token.new(:INTEGER, '3', 5),
        Token.new(:R_PAREN, ')', 6),
        Token.new(:ASTERISK, '*', 7),
        Token.new(:INTEGER, '4', 8),
        Token.new(:SLASH, '/', 9),
        Token.new(:INTEGER, '3', 10),
        Token.new(:R_PAREN, ')', 11),
        Token.new(:D, 'd', 12),
        Token.new(:INTEGER, '6', 13),
        Token.new(:ASTERISK, '*', 14),
        Token.new(:INTEGER, '2', 15),
        Token.new(:PLUS, '+', 16),
        Token.new(:INTEGER, '5', 17),
        Token.new(:EOS, '', 18)
      ])
    )
    data(
      '[1...5]D6'.inspect,
      LexerTestData.new('[1...5]D6', [
        Token.new(:L_BRACKET, '[', 1),
        Token.new(:INTEGER, '1', 2),
        Token.new(:DOTS, '...', 3),
        Token.new(:INTEGER, '5', 6),
        Token.new(:R_BRACKET, ']', 7),
        Token.new(:D, 'D', 8),
        Token.new(:INTEGER, '6', 9),
        Token.new(:EOS, '', 10)
      ])
    )
    data(
      '[1..5]D6'.inspect,
      LexerTestData.new('[1..5]D6', [
        Token.new(:L_BRACKET, '[', 1),
        Token.new(:INTEGER, '1', 2),
        Token.new(:ILLEGAL, '.', 3),
        Token.new(:ILLEGAL, '.', 4),
        Token.new(:INTEGER, '5', 5),
        Token.new(:R_BRACKET, ']', 6),
        Token.new(:D, 'D', 7),
        Token.new(:INTEGER, '6', 8),
        Token.new(:EOS, '', 9)
      ])
    )
    data(
      '2d6/3u'.inspect,
      LexerTestData.new('2d6/3u', [
        Token.new(:INTEGER, '2', 1),
        Token.new(:D, 'd', 2),
        Token.new(:INTEGER, '6', 3),
        Token.new(:SLASH, '/', 4),
        Token.new(:INTEGER, '3', 5),
        Token.new(:U, 'u', 6),
        Token.new(:EOS, '', 7)
      ])
    )
    data(
      '2d6/3r'.inspect,
      LexerTestData.new('2d6/3r', [
        Token.new(:INTEGER, '2', 1),
        Token.new(:D, 'd', 2),
        Token.new(:INTEGER, '6', 3),
        Token.new(:SLASH, '/', 4),
        Token.new(:INTEGER, '3', 5),
        Token.new(:R, 'r', 6),
        Token.new(:EOS, '', 7),
      ])
    )
    data(
      '2d6=7'.inspect,
      LexerTestData.new('2d6=7', [
        Token.new(:INTEGER, '2', 1),
        Token.new(:D, 'd', 2),
        Token.new(:INTEGER, '6', 3),
        Token.new(:EQ, '=', 4),
        Token.new(:INTEGER, '7', 5),
        Token.new(:EOS, '', 6)
      ])
    )
    data(
      '2d6>7'.inspect,
      LexerTestData.new('2d6>7', [
        Token.new(:INTEGER, '2', 1),
        Token.new(:D, 'd', 2),
        Token.new(:INTEGER, '6', 3),
        Token.new(:GT, '>', 4),
        Token.new(:INTEGER, '7', 5),
        Token.new(:EOS, '', 6)
      ])
    )
    data(
      '2d6<7'.inspect,
      LexerTestData.new('2d6<7', [
        Token.new(:INTEGER, '2', 1),
        Token.new(:D, 'd', 2),
        Token.new(:INTEGER, '6', 3),
        Token.new(:LT, '<', 4),
        Token.new(:INTEGER, '7', 5),
        Token.new(:EOS, '', 6)
      ])
    )
    data(
      '2d6>=7'.inspect,
      LexerTestData.new('2d6>=7', [
        Token.new(:INTEGER, '2', 1),
        Token.new(:D, 'd', 2),
        Token.new(:INTEGER, '6', 3),
        Token.new(:GTEQ, '>=', 4),
        Token.new(:INTEGER, '7', 6),
        Token.new(:EOS, '', 7)
      ])
    )
    data(
      '2d6<=7'.inspect,
      LexerTestData.new('2d6<=7', [
        Token.new(:INTEGER, '2', 1),
        Token.new(:D, 'd', 2),
        Token.new(:INTEGER, '6', 3),
        Token.new(:LTEQ, '<=', 4),
        Token.new(:INTEGER, '7', 6),
        Token.new(:EOS, '', 7)
      ])
    )
    data(
      '2d6<>7'.inspect,
      LexerTestData.new('2d6<>7', [
        Token.new(:INTEGER, '2', 1),
        Token.new(:D, 'd', 2),
        Token.new(:INTEGER, '6', 3),
        Token.new(:DIAMOND, '<>', 4),
        Token.new(:INTEGER, '7', 6),
        Token.new(:EOS, '', 7)
      ])
    )
    data(
      '2b6+4b10'.inspect,
      LexerTestData.new('2b6+4b10', [
        Token.new(:INTEGER, '2', 1),
        Token.new(:B, 'b', 2),
        Token.new(:INTEGER, '6', 3),
        Token.new(:PLUS, '+', 4),
        Token.new(:INTEGER, '4', 5),
        Token.new(:B, 'b', 6),
        Token.new(:INTEGER, '10', 7),
        Token.new(:EOS, '', 9)
      ])
    )
    data(
      '2b6+4b10>3'.inspect,
      LexerTestData.new('2b6+4b10>3', [
        Token.new(:INTEGER, '2', 1),
        Token.new(:B, 'b', 2),
        Token.new(:INTEGER, '6', 3),
        Token.new(:PLUS, '+', 4),
        Token.new(:INTEGER, '4', 5),
        Token.new(:B, 'b', 6),
        Token.new(:INTEGER, '10', 7),
        Token.new(:GT, '>', 9),
        Token.new(:INTEGER, '3', 10),
        Token.new(:EOS, '', 11)
      ])
    )

    test '字句解析で正しいトークンを返す' do |data|
      lexer = Lexer.new(data.input)

      actual = []
      data.expected.length.times do
        actual << lexer.next_token
      end

      assert_equal(data.expected, actual)
    end
  end
end
