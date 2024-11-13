{ lib
, stdenv
, gcc
, gnumake
, SDL
, SDL_image
, guile_2_2
, pkg-config
}:

let
  pname = "libgraph";
  version = "1.0.2";

  meta = {
    description = "libgraph is an implementation of the TurboC graphics API
    (graphics.h) on GNU/Linux using SDL";
    homepage = "https://savannah.nongnu.org/projects/libgraph/";
    license = with lib.licenses; [ gpl2 ];
    maintainers = with lib.maintainers; [ prestonhager ];
    platforms = [ "x86_64-linux" ];
  };
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchTarball {
    url = "https://download.savannah.nongnu.org/releases/libgraph/libgraph-1.0.2.tar.gz";
    sha256 = "sha256:0l3gjvqjf2rr6iax599f3wmb0ymzmmgdy7mk2zmbh08phyjnxy5d";
  };

  nativeBuildInputs = [
    gcc
    gnumake

    SDL
    SDL_image
#    guile_2_2
    pkg-config
  ];

  configurePhase = ''
    export CPPFLAGS="$CPPFLAGS -I${SDL}/include/SDL -I${SDL_image}/include/SDL -fcommon"
    export CFLAGS="$CFLAGS -I${SDL}/include/SDL -I${SDL_image}/include/SDL -fcommon"
    export LDFLAGS="$LDFLAGS -L${SDL}/lib -L${SDL_image}/lib"
    ./configure --prefix=$out --disable-guile
  '';

  buildPhase = ''
    make
  '';

  installPhase = ''
    make install
  '';
}

