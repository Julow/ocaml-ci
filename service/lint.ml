open Current.Syntax
module Docker = Conf.Builder_amd1

type ocamlformat_version = [
  | `Vendored
  | `Version of string
]

let ocamlformat ~dune_version ~ocamlformat_version ~base ~src =
  let dockerfile =
    let open Dockerfile in
    let+ base = base
    and+ install_ocamlformat =
      let+ ocamlformat_version = ocamlformat_version in
      match ocamlformat_version with
      | `Vendored -> empty
      | `Version v ->
        run "opam depext ocamlformat=%s" v
        @@ run "opam install ocamlformat=%s" v
    and+ dune_version = dune_version in
    from (Docker.Image.hash base)
    @@ run "opam install dune=%s" dune_version
    @@ install_ocamlformat
    @@ copy ~chown:"opam" ~src:["./"] ~dst:"./src" ()
    @@ workdir "src"
  in
  let img =
    Docker.build ~label:"OCamlformat" ~pool:Docker.pool ~pull:false ~dockerfile (`Git src)
  in
  Docker.run ~label:"lint" img ~args:[ "sh"; "-c"; "dune build @fmt || (echo \"dune build @fmt failed\"; exit 2)" ]
