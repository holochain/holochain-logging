let
 release-commit = "33bca0fe47fac18d156968cb1432844c1af3663c";
 current = "0.0.7";
 previous = "_._._";

 # tag will ultimately be current version when it hits holonix
 # https://github.com/holochain/holonix/blob/master/release/default.nix#L7
 tag = "v${current}";

 holonix-version = "v0.0.65";
 holonix-sha256 = "1frw8z1d3qdly2lcs7z4liwkkqgb344h7p7n1xzpwaqhhm0xa0kd";
in
rec {

 # configure holonix itself
 holonix = {

  # true = use a github repository as the holonix base (recommended)
  # false = use a local copy of holonix (useful for debugging)
  use-github = true;

  # configure the remote holonix github when use-github = true
  github = {

   # can be any github ref
   # branch, tag, commit, etc.
   ref = holonix-version;

   # the sha of what is downloaded from the above ref
   # note: even if you change the above ref it will not be redownloaded until
   #       the sha here changes (the sha is the cache key for downloads)
   # note: to get a new sha, get nix to try and download a bad sha
   #       it will complain and tell you the right sha
   sha256 = holonix-sha256;

   # the github owner of the holonix repo
   owner = "holochain";

   # the name of the holonix repo
   repo = "holonix";
  };

  # configuration for when use-github = false
  local = {
   # the path to the local holonix copy
   path = ../holonix;
  };

 };

 release = {
  hook = {
   # sanity checks before deploying
   # to stop the release
   # exit 1
   preflight = ''
'';

   # bump versions in the repo
   version = ''
hn-release-hook-version-rust
hl-release-hook-version
'';

   # publish artifacts to the world
   publish = ''
'';
  };

  # the commit hash that the release process should target
  # this will always be behind what ends up being deployed
  # the release process needs to add some commits for changelog etc.
  commit = release-commit;

  # the semver for prev and current releases
  # the previous version will be scanned/bumped by release scripts
  # the current version is what the release scripts bump *to*
  version = {
   current = current;
   # not used by version hooks in this repo
   previous = previous;
  };

  github = {
   # markdown to inject into github releases
   # there is some basic string substitution {{ xxx }}
   # - {{ changelog }} will inject the changelog as at the target commit
   template = ''
   {{ changelog }}
'';

   # owner of the github repository that release are deployed to
   owner = "holochain";

   # repository name on github that release are deployed to
   repo = "holochain-logging";

   # canonical local upstream name as per `git remote -v`
   upstream = "origin";

  };

  # non-standard, overridden by holonix internally anyway
  # used by check artifacts
  tag = tag;
 };
}
