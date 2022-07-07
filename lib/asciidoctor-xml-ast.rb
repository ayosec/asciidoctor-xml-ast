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
      if not value.nil?
        value = CGI.escapeHTML(value.to_s)
        attributes << %[ attr-#{name}="#{value}"]
      end
    end

    # Element body.
    result = []

    result << "<#{element_name}#{attributes.join}>"

    if node.respond_to?(:text)
      result << node.text
    end

    if node.block?
      append_content(result, node.content)
    end

    result << "</#{element_name}>"
    result.join
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
