# frozen_string_literal: true

require 'strscan'

require 'toybox_vm/token'

module ToyboxVm
  class Lexer
    ONE_CHAR_TOKEN_TYPE = {
      '+' => :PLUS,
      '-' => :MINUS,
      '*' => :ASTERISK,
      '/' => :SLASH,

      '=' => :EQ,
      '(' => :L_PAREN,
      ')' => :R_PAREN,
      '[' => :L_BRACKET,
      ']' => :R_BRACKET
    }

    RESERVED = {
      'D' => :D,
      'B' => :B,
      'R' => :R,
      'U' => :U
    }

    # 入力文字列
    # @return [String]
    attr_reader :input

    # 字句解析器を初期化する
    # @param [String] input 入力文字列
    def initialize(input)
      @input = input
      @scanner = StringScanner.new(input)
    end

    # トークンが何文字目で発見されたか
    # @return [Integer]
    #
    # 利用者に示すものなので、1-indexed。
    def column
      @scanner.pos + 1
    end

    def next_token
      column_before_scan = column

      case
      when @scanner.eos?
        return Token.new(:EOS, '', column_before_scan)
      when @scanner.scan(/\.{3}/)
        return Token.new(:DOTS, @scanner[0], column_before_scan)
      when @scanner.scan(/<([=>])?/)
        case @scanner[1]
        when '='
          return Token.new(:LTEQ, @scanner[0], column_before_scan)
        when '>'
          return Token.new(:DIAMOND, @scanner[0], column_before_scan)
        else
          return Token.new(:LT, @scanner[0], column_before_scan)
        end
      when @scanner.scan(/>(=)?/)
        if @scanner[1]
          return Token.new(:GTEQ, @scanner[0], column_before_scan)
        end

        return Token.new(:GT, @scanner[0], column_before_scan)
      when @scanner.scan(%r![-+*/()\[\]=]!)
        return Token.new(ONE_CHAR_TOKEN_TYPE[@scanner[0]],
                         @scanner[0],
                         column_before_scan)
      when @scanner.scan(/\d+/)
        return Token.new(:INTEGER, @scanner[0], column_before_scan)
      when @scanner.scan(/[A-Z]+/i)
        return Token.new(RESERVED[@scanner[0].upcase] || :IDENT,
                         @scanner[0],
                         column_before_scan)
      else
        ch = @scanner.getch
        return Token.new(:ILLEGAL, ch, column_before_scan)
      end
    end
  end
end
