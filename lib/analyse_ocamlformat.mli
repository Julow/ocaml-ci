type source =
  | Opam of { version : string } (** Should install OCamlformat from Opam. *)
  | Vendored of { path : string } (** OCamlformat is vendored. [path] is relative to the project's root. *)
[@@deriving yojson,eq]

val get_ocamlformat_source : Current.Job.t -> opam_files:string list -> root:Fpath.t -> source option Lwt.t
(** Detect the required version of OCamlformat or if it's vendored.
    Vendored OCamlformat is detected by looking at file names in [opam_files]. *)
