require 'forwardable'

class GraphQLFormatter
  extend Forwardable

  autoload :CharacterString, 'graphql-formatter/character_string'
  autoload :LineCollection, 'graphql-formatter/line_collection'
  autoload :LineOfCharacterStrings, 'graphql-formatter/line_of_character_strings'
  autoload :VERSION, 'graphql-formatter/version'

  attr_reader :result, :in_parens
  def_delegators :result, :new_line, :new_string, :previous_string, :current_string,
                 :current_line, :last_character, :current_indent_level, :to_s,
                 :current_color

  def initialize(input)
    @input     = input
    @result    = LineCollection.new
    @in_parens = false
    parse!
  end

  private

  def parse!
    @input.chars do |char|
      case char
      when '('
        parse_open_paren
      when ')'
        parse_open_close_paren
      when '{'
        parse_open_bracket
      when '}'
        parse_close_bracket
      when ':'
        parse_colon
      when ','
        parse_comma
      when ' '
        parse_space
      else
        parse_character char
      end
    end
  end

  def parse_open_paren
    @in_parens = true
    new_string << '('
    new_string color: :light_yellow
  end

  def parse_open_close_paren
    @in_parens = false
    new_string << ')'
  end

  def parse_open_bracket
    current_string << ' ' unless last_character == ' '
    new_string << '{'
    new_line indent_level: current_indent_level + 1
    new_string color: :light_blue
  end

  def parse_close_bracket
    current_string << ' ' unless last_character == ' ' || current_line.empty?
    new_line indent_level: current_indent_level - 1
    new_string << '}'
    new_line
  end

  def parse_colon
    new_string << ':'
    new_string color: in_parens ? :yellow : :blue
  end

  def parse_comma
    (last_character == '}' ? previous_string : new_string) << ','
    if in_parens
      new_string(color: :light_yellow)
    else
      new_line unless current_line.empty?
      new_string(color: :light_blue)
    end
  end

  def parse_space
    if current_indent_level == 0
      new_color =
        case current_color
        when :light_green
          :light_magenta
        when :light_magenta
          nil
        when nil
          :light_cyan
        else
          current_color
        end
      new_string color: new_color
    end
    current_string << ' ' unless current_line.empty?
  end

  def parse_character(char)
    current_string << ' ' if in_parens && %w{: ,}.include?(last_character)
    new_string color: :light_green if current_indent_level == 0 && current_line.empty?
    current_string.color = :magenta if current_string.end_with? '...'
    current_string << char
  end

end
