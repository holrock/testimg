(lang dune 3.0)

(name filterimg)

(generate_opam_files true)

(source
 (github username/reponame))

(authors "Author Name")

(maintainers "Maintainer Name")

(license LICENSE)

(documentation https://url/to/documentation)

(package
 (name filterimg)
 (synopsis "A short synopsis")
 (description "A longer description")
 (depends
   ocaml
   dune
   dream
   caqti-driver-sqlite3
   ppx_yojson_conv
   js_of_ocaml
   js_of_ocaml-ppx
   (ssl (= 0.5.9)))
 (tags
  (topics "to describe" your project)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
