@0x9ac524e0ec04d45e;

using OCurrent = import "ocurrent.capnp";

struct RefInfo {
  ref  @0 :Text;
  hash @1 :Text;
}

struct JobInfo {
  variant @0 :Text;
  state :union {
    notStarted @1 :Void;

    passed     @2 :Void;

    failed     @3 :Text;
    # The text is the error message.

    active     @4 :Void;
    # The job is still running.

    aborted    @5 :Void;
    # This means we couldn't find any record of the job. It probably means
    # that the server crashed while building, and when it came back up we
    # no longer wanted to test that commit anyway.
  }
}

interface Commit {
  jobs  @0 () -> (jobs :List(JobInfo));

  jobOfVariant @1 (variant :Text) -> (job :OCurrent.Job);

  refs @2 (hash :Text) -> (refs :List(Text));
  # Get the set of branches and PRs with this commit at their head.
}

interface Repo {
  refs         @0 () -> (refs :List(RefInfo));
  # Get the set of branches and PRs being monitored.

  deprecatedJobOfCommit  @1 (hash :Text) -> (job :OCurrent.Job);
  deprecatedJobOfRef     @2 (ref :Text) -> (job :OCurrent.Job);
  deprecatedRefsOfCommit @3 (hash :Text) -> (refs :List(Text));

  commitOfHash @4 (hash :Text) -> (commit :Commit);
  # The hash doesn't need to be the full hash, but must be at least 6 characters long.

  commitOfRef @5 (ref :Text) -> (commit :Commit);
  # ref should be of the form "refs/heads/..." or "refs/pull/4/head"
}

interface Org {
  repo         @0 (name :Text) -> (repo :Repo);

  repos        @1 () -> (repos :List(Text));
  # Get the list of tracked repositories for this organisation.
}

interface CI {
  org          @0 (owner :Text) -> (org :Org);

  orgs         @1 () -> (orgs :List(Text));
  # Get the list of organisations for this CI capability.
}
