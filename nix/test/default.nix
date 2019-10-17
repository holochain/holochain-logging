{ pkgs }:
let
  name = "hl-test";

  script = pkgs.writeShellScriptBin name
  ''
  set -euo pipefail
  cargo test
  '';
in
{
 buildInputs = [ script ]
 ;
}
