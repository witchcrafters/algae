# Used by "mix format"
[
  inputs: ["mix.exs", "{config,lib,test}/**/*.{ex,exs}"],
  locals_without_parens: [
    defdata: :*,
    defsum: 1
  ],
  import_deps: [
    :operator,
    :quark,
    :type_class
  ]
]
