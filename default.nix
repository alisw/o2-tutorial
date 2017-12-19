{ nixpkgs ? import <nixpkgs> {} }:
with nixpkgs.pkgs;

{
  o2_tutorial = stdenv.mkDerivation {

    name = "o2-tutorial";
    version = "1";
    src = ./.;
    buildInputs = [
      elmPackages.elm
      rsync
    ];
  };
}
