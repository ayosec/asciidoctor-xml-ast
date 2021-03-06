# asciidoctor-ast-xml

This repository implements an [Asciidoctor converter] to generate a XML file
with the syntax nodes of a parsed document.

## Usage

The converter is available as a Ruby gem, and can be installed with the
following command:

```console
$ gem install asciidoctor-xml-ast
```

The gem includes the executable `asciidoctor-xml-ast`, which you can use instead
of `asciidoctor`:

```console
$ asciidoctor-xml-ast document.adoc
```

Alternatively, you can invoke `asciidoctor` directly, and add the options
`--require asciidoctor-ast-xml` and `--backend xml-ast`:

```console
$ asciidoctor -r asciidoctor-xml-ast -b xml-ast document.adoc
```

In the previous examples, the output will be in the `document.ast.xml` file.

## Example

The following document:

```asciidoc
= Lorem Ipsum

== Dolor Sit Amet

Cillum dolore eu *fugiat* nulla pariatur
```

Generates a XML like this:

```xml
<document title="Lorem Ipsum" ... >
  <section id="_dolor_sit_amet" title="Dolor Sit Amet">
    <paragraph>Cillum dolore eu <inline-quoted type="strong">fugiat</inline-quoted> nulla pariatur</paragraph>
  </section>
</document>
```

The `<document>` element contains a lot of attributes, which have been removed
in this example so it is easier to read.

The actual output is not indented. The previous example is formatted with [xmllint].



[Asciidoctor converter]: https://docs.asciidoctor.org/asciidoctor/latest/convert/
[xmllint]: https://gnome.pages.gitlab.gnome.org/libxml2/xmllint.html
