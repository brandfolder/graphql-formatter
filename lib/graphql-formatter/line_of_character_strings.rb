class GraphQLFormatter::LineOfCharacterStrings
  include Enumerable
  extend Forwardable

  attr_reader :strings
  attr_accessor :indent_level

  def_delegators :strings, :each

  def initialize(indent_level: 0)
    self.indent_level = indent_level
    @strings          = [GraphQLFormatter::CharacterString.new]
  end

  def new_string(color: nil, **opts)
    return current_string if color == current_color
    if current_string.empty?
      current_string.color = color
      return current_string
    end
    GraphQLFormatter::CharacterString.new(color: color, **opts).tap do |string|
      @strings << string
    end
  end

  def last_char
    (current_string && current_string.last_char) ||
      (previous_string && previous_string.last_char)
  end

  def previous_string
    @strings[-2]
  end

  def current_string
    @strings.last
  end

  def current_color
    current_string.color
  end

  def empty?
    strings.all? &:empty?
  end

  def to_s(indenter: (' ' * 4), **opts)
    indent = indenter * indent_level
    indent + reject(&:empty?).map { |str| str.to_s(**opts) }.join
  end
end
