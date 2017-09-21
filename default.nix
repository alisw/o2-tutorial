with import <nixpkgs> {};

stdenv.mkDerivation {
 name = "o2-tutorial";
 src = ./.;

# myNode = nodePackages (p: with p; [file]);
 buildInputs = [ elmPackages.elm nodejs nodePackages.webpack nodePackages.file ];

 patchPhase = ''
#   patchShebangs node_modules/webpack
 '';
 buildPhase = ''
   npm run build
 '';
 installPhase = ''
   mkdir $out
   cp dist/* $out/
 '';
}

