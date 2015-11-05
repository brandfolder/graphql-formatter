class GraphQLFormatter::LineCollection
  include Enumerable
  extend Forwardable

  attr_reader :lines

  def initialize
    @lines = [GraphQLFormatter::LineOfCharacterStrings.new]
  end

  def_delegators :current_line, :current_color, :current_string
  def_delegators :lines, :each

  def current_line
    lines.last
  end

  def new_line(indent_level: current_indent_level, **opts)
    GraphQLFormatter::LineOfCharacterStrings.new(indent_level: indent_level, **opts).tap do |line|
      lines << line
    end
  end

  def new_string(**opts)
    current_line.new_string(**opts)
  end

  def previous_line
    lines[-2]
  end

  def previous_string
    current_line.previous_string || previous_line.current_string
  end

  def current_indent_level
    current_line.indent_level
  end

  def last_character
    (current_line && current_line.last_char) ||
      (previous_line && previous_line.last_char)
  end

  def to_s(**opts)
    reject(&:empty?).map { |line| line.to_s(**opts) }.join("\n")
  end
end
