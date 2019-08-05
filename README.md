# Toybox VM

Evaluates dice rolls and stores the result for tabletop RPG tools.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'toybox_vm'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install toybox_vm

## Usage

**NOTE**: Toybox VM is in the design stage.

Load `toybox_vm`.

```ruby
require 'toybox_vm'
```

Parse a command and build the abstract syntax tree (AST).
The syntax is based on [BCDice][BCDice], that is used by [DodontoF][DodontoF] for the dice rolling feature, but is not completely implemented yet.

On `bin/console`, the parser is provided as a global variable `$parser` for quick testing.

```ruby
parser = ToyboxVm::DiceRollLangParser.new
syntax_tree = parser.parse('2d6+1')
ast = syntax_tree.to_ast
#=> #<struct ToyboxVm::Ast::Add
#    left=
#     #<struct ToyboxVm::Ast::AddRoll
#      num_of_dice=#<struct ToyboxVm::Ast::Number value=2>,
#      max_value=#<struct ToyboxVm::Ast::Number value=6>>,
#    right=#<struct ToyboxVm::Ast::Number value=1>>

# Shorthand way
ast = parser.ast('2d6+1')
```

You can convert the AST to the infix notation or the S-expression.

```ruby
# Infix notation
ast.to_s
#=> "2D6 + 1"

# S-expression
ast.to_s_exp
#=> "(+ (add-roll 2 6) 1)"
```

To get the result, create a virtual machine (VM) and evaluate the AST on it.

```ruby
machine = ToyboxVm::Machine.new(ast)
result = machine.run
#=> #<struct ToyboxVm::Ast::Number value=12>

result.value
#=> 12

machine.state.roll_results.map { |r| [r.value, r.max_value] }
#=> [[5, 6], [6, 6]]
```

You can format the result for your tabletop RPG tool.

For testing, you can provide dice rolling results on creating a VM.

```ruby
roll_results = [
  ToyboxVm::Ast::DieRollResult.new(2, 6),
  ToyboxVm::Ast::DieRollResult.new(5, 6)
]

ast = parser.ast('2d6')
machine = ToyboxVm::Machine.new(ast, roll_results)
result = machine.run

result.value
#=> 7
machine.state.roll_results.map { |r| [r.value, r.max_value] }
#=> [[2, 6], [5, 6]]
```

## Implemented syntax

Toybox VM's syntax is written in [parsing expression grammar (PEG)][PEG] with [Treetop][Treetop]. The syntax file is [lib/toybox_vm/dice_roll_lang.treetop](lib/toybox_vm/dice_roll_lang.treetop).

Spaces must not be inserted between characters.

### Arithmetic operations

Arithmetic operations will be reduced to a `Number` (integer) node.

* Addition (`+`)
* Subtraction (`-`)
    * Sign inversion is not implemented yet.
* Multiplication (`*`)
* Division (`/`)
* Parentheses (`()`): modifiy precedence rules.

#### Examples

```
1+2 -> 3
1+2*3 -> 7
(11-4)/2 -> 3
```

### Comparisons

Comparisons will be reduced to a `Boolean` node.

* Less than (`<`)

#### Examples

```
1<3 -> true
3*4<2*5 -> false
```

### Random number in range

A random number in range (`NumRange`; e.g. `[1...9]`) will be reduced to a `Number` node which value is in the specified range, and the value will be recorded.

#### Examples

```
# Result is in the closed interval [1, 9]
[1...9] -> 4
[1..9] -> 7
```

### Dice notation

* Sum (e.g. `2d6`, `2D6`): will be reduced to a `Number` node which value is the sum of dice, and the value of each die will be recorded.
    * You can include arithmetic operations and random numbers to the number of dice (e.g. `(1+2*3)d6`, `[2...4]d10`, `(2*[0...2]+1)d4`).

#### Examples

```
# The dice are 2 and 5
2d6 -> 7
(3-1)D10*2 -> 14
```

## ToDo

* Implement the syntax and the features of [BCDice][BCDice] as much as possible
* Enable displaying the reduction process
    * Example on BCDice: `(2D6+1) ＞ 11[5,6]+1 ＞ 1`
* Create the result formatter

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ochaochaocha3/toybox_vm.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

[BCDice]: https://github.com/torgtaitai/BCDice
[DodontoF]: http://www.dodontof.com/
[PEG]: https://en.wikipedia.org/wiki/Parsing_expression_grammar
[Treetop]: http://cjheath.github.io/treetop/
