require "cgi"

class AstConverter
  include Asciidoctor::Converter
  register_for "xml-ast"

  def initialize(*args)
    super
    outfilesuffix ".ast.xml"
  end

  def convert(node, transform = node.node_name)
    element_name = transform.tr("_", "-")

    # Element attributes.
    attributes = []

    %i(id target title type).each do |name|
      if node.respond_to?(name) and value = node.send(name) and not value.nil?
        value = CGI.escapeHTML(value.to_s)
        attributes << %[ #{name}="#{value}"]
      end
    end

    node.attributes.each_pair do |name, value|
      next if value.nil?

      Array(value).each do |value|
        if value.kind_of?(Asciidoctor::Document::AttributeEntry)
          value = value.value
        end

        value = CGI.escapeHTML(value.to_s)
        attributes << %[ attr-#{name}="#{value}"]
      end
    end

    if transform == "table" and node.title?
      attributes << %[ table-caption="#{node.captioned_title}"]
    end

    # Element body.
    result = []

    result << "<#{element_name}#{attributes.join}>"

    if node.respond_to?(:text) and transform != "table_cell"
      result << node.text
    end

    if transform == "table"
      convert_table(result, node)
    end

    if node.block?
      append_content(result, node.content)
    end

    result << "</#{element_name}>"
    result.join
  end

  def convert_table(result, node)
    node.rows.to_h.each do |section, rows|
      next if rows.empty?

      section_element = "table-#{section}"

      result << "<#{section_element}>"
      rows.each do |row|
        result << "<table-row>"
        row.each do |cell|
          result << cell.convert
        end
        result << "</table-row>"
      end
      result << "</#{section_element}>"
    end
  end

  def append_content(result, content)
    case content
    when Array
      content.each do |i|
        append_content(result, i)
      end

    when String
      result << content

    when Asciidoctor::AbstractNode
      result << content.convert

    when nil
      # Nothing to add.

    else
      raise "Invalid content type: #{content.class}"

    end
  end
end
