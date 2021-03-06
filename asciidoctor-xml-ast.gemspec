Gem::Specification.new do |s|
  s.name        = "asciidoctor-xml-ast"
  s.version     = "0.2.0"
  s.licenses    = %w(MIT)
  s.authors     = %w(ayosec)
  s.homepage    = "https://github.com/ayosec/asciidoctor-xml-ast"

  s.summary     = "Converter for Asciidoctor syntax to XML"
  s.description = <<-DESC
    Asciidoctor converter to generate a XML file with the syntax
    nodes from a parsed document.
  DESC

  s.files = Dir[
    "README.md",
    "bin/asciidoctor-xml-ast",
    "lib/*.rb"
  ]

  s.bindir = "bin"
  s.require_paths = %w(lib)

  s.executables = %w(asciidoctor-xml-ast)

  s.add_runtime_dependency "asciidoctor", "~> 2.0"
end
