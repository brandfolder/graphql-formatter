require 'colorize'

class GraphQLFormatter::CharacterString
  extend Forwardable
  attr_reader :string
  attr_accessor :color

  def_delegators :string, :empty?, :end_with?, :chars, :<<

  def initialize(color: nil)
    self.color = color
    @string    = ''
  end

  def last_char
    chars.last
  end

  def to_s(colorize: true)
    colorize ? string.colorize(color) : string
  end
end
