(** Build and test all the opam packages.
    [~variant] is the variant of the "ocurrent/opam" image.
    [~repo] is used to identify a build cache for duniverse projects. *)
val v :
  docker:(module S.DOCKER_CONTEXT) ->
  variant:string ->
  repo:Current_github.Repo_id.t Current.t ->
  analysis:Analyse.Analysis.t Current.t ->
  Current_git.Commit.t Current.t ->
  [> `Built ] Current.t
