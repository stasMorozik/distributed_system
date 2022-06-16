# Used by "mix format"

locals_without_parens = [

]

[
  inputs: ["mix.exs", "config/*.exs"],
  subdirectories: ["apps/*"],
  line_length: 80,
  locals_without_parens: locals_without_parens
]
