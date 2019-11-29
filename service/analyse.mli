module Analysis : sig
  type ocamlformat_version = Version of string | Vendored

  (** A project is a directory with a dune-project file in it *)
  type project = {
    project_path : string;
    project_dune_version : string option; (** The (lang dune ..) field *)
    project_name : string option; (** The (name ..) field *)
  }

  type t

  val opam_files : t -> string list
  val is_duniverse : t -> bool
  val ocamlformat_version : t -> ocamlformat_version option
  val projects : t -> project list
  val root_project : t -> project
end

val examine : Current_git.Commit.t Current.t -> Analysis.t Current.t
(** [examine src] returns a list of "*.opam" files in [src]. *)
