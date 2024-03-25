(lang dune 3.14)

(name terml)

(generate_opam_files true)

(source
 (github wllfaria/terml))

(authors "Willians Faria <dev.willians.faria@gmail.com>")

(maintainers "Willians Faria <dev.willians.faria@gmail.com>")

(license MIT)

(version 0.0.1)

(package
 (name terml)
 (synopsis "Terml is a pure-ocaml library for manipulating terminal output. Making possible to write text-based interfaces with ease")
 (description "Terml is a pure-ocaml library for manipulating terminal output. Making possible to write text-based interfaces with ease")
 (depends 
   (ocaml  (>= "5.1"))
   (uutf (>= "1.0.3")))
 (tags
   (tui terminal "terminal-tui")))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
