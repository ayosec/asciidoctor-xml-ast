require "nokogiri"
require "tempfile"

RSpec.describe do

  it "converts an Asciidoctor file" do

    # Convert a document to XML.

    input = Tempfile.new("adoc")
    input.write <<~SOURCE
      = Lorem Ipsum

      == Dolor Sit Amet

      Cillum dolore eu *fugiat* nulla pariatur
    SOURCE
    input.close

    output = Tempfile.new("xml-ast")
    output.close

    success = system(
      "asciidoctor",
        "--require", "asciidoctor-xml-ast",
        "--backend", "xml-ast",
        "--out-file", output.path,
        input.path
    )

    expect(success).to eq(true)

    # Check if the expected XML elements are present.

    xml = Nokogiri::XML.parse(File.read(output.path))
    expect(xml.at(%(document))["attr-doctitle"])         .to eq("Lorem Ipsum")
    expect(xml.at(%(section))["title"])                  .to eq("Dolor Sit Amet")
    expect(xml.at(%(inline-quoted[type="strong"])).text) .to eq("fugiat")

  end

end
