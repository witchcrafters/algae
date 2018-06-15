# Used by "mix format"
[
  inputs: ["mix.exs", "{config,lib,test}/**/*.{ex,exs}"],
  locals_without_parens: [
    defdata: :*,
    defsum: 1
  ],
  export: [
    locals_without_parens: [
      defdata: :*,
      defsum: 1
    ]
  ],
  import_deps: [
    :quark,
    :type_class,
    :witchcraft
  ]
]
